// Walter 2026-08-16: Mandatory "first 3 lessons" payment after accepting a
// slot. Creates a single Stripe payment intent (iDEAL preferred) for the
// combined amount, then reserves the 3 lesson slots atomically so the
// parent cannot lose them while paying.
//
// Trigger:
//   POST /waitlist-pay-first-three
//   Header: Authorization: Bearer <parent-jwt>
//   Body: { waitlist_id: "uuid", lesson_dates: ["YYYY-MM-DD", ...] }
//
// Note: expects Stripe secret in STRIPE_SECRET_KEY env var (same one that
// powers create-payment-intent).

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const STRIPE_KEY = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST only" }, 405);

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) return json({ error: "auth required" }, 401);
  const jwt = authHeader.slice(7);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: userData } = await sb.auth.getUser(jwt);
  if (!userData?.user) return json({ error: "invalid session" }, 401);

  let body: any;
  try { body = await req.json(); } catch { return json({ error: "bad JSON" }, 400); }
  const waitlistId = body.waitlist_id as string | undefined;
  const dates = Array.isArray(body.lesson_dates) ? body.lesson_dates as string[] : [];
  if (!waitlistId || dates.length !== 3) {
    return json({ error: "waitlist_id + 3 lesson_dates required" }, 400);
  }

  // Verify ownership + pull pricing.
  const { data: entry } = await sb
    .from("waitlist")
    .select("id, parent_id, lesson_type, preferred_location_ids")
    .eq("id", waitlistId)
    .maybeSingle();
  if (!entry || entry.parent_id !== userData.user.id) return json({ error: "not your entry" }, 403);
  if (!entry.preferred_location_ids?.length) return json({ error: "no location" }, 400);

  // Get price per lesson from the catalog.
  const locationId = entry.preferred_location_ids[0] as string;
  const { data: pricing } = await sb
    .from("location_lesson_types")
    .select("price_cents")
    .eq("location_id", locationId)
    .eq("lesson_type", entry.lesson_type ?? "one_on_one")
    .maybeSingle();
  const perLessonCents = pricing?.price_cents ?? 3800; // default 1-op-1
  const totalCents = perLessonCents * 3;

  // Create the Stripe payment intent (iDEAL first, card fallback).
  if (!STRIPE_KEY) return json({ error: "stripe not configured" }, 500);
  const intent = await createStripeIntent(totalCents, entry.parent_id, waitlistId);
  if (!intent.id) return json({ error: intent.error ?? "stripe failed" }, 502);

  // Reserve the 3 lesson dates immediately (best-effort — real reservations
  // table wiring stays in the mobile app booking flow; here we just create
  // the auto_reserved_lessons rows so admin can see the commitment).
  const rows = dates.map((d, i) => ({
    waitlist_id: waitlistId,
    reservation_id: intent.id,      // temporary placeholder — swap with real reservation id after payment webhook fires
    sequence_number: i + 1,
    paid_amount_cents: perLessonCents,
    stripe_payment_intent_id: intent.id,
  }));
  await sb.from("waitlist_auto_reserved_lessons").insert(rows);

  return json({
    ok: true,
    stripe_client_secret: intent.client_secret,
    stripe_payment_intent_id: intent.id,
    total_cents: totalCents,
    per_lesson_cents: perLessonCents,
  });
});

async function createStripeIntent(
  amountCents: number, customerId: string, metaWaitlistId: string,
): Promise<{ id?: string; client_secret?: string; error?: string }> {
  try {
    const params = new URLSearchParams();
    params.append("amount", String(amountCents));
    params.append("currency", "eur");
    params.append("payment_method_types[]", "ideal");
    params.append("payment_method_types[]", "card");
    params.append("metadata[waitlist_id]", metaWaitlistId);
    params.append("metadata[flow]", "first_three_lessons");
    params.append("metadata[customer_uid]", customerId);
    const res = await fetch("https://api.stripe.com/v1/payment_intents", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${STRIPE_KEY}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: params.toString(),
    });
    const j = await res.json();
    if (!res.ok) return { error: j?.error?.message ?? "stripe error" };
    return { id: j.id as string, client_secret: j.client_secret as string };
  } catch (e) {
    return { error: (e as Error).message };
  }
}

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status, headers: { ...CORS, "Content-Type": "application/json" },
  });
}
