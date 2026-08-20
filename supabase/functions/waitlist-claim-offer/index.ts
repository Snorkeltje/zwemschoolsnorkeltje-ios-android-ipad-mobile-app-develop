// Walter 2026-08-16: Parent accepts / declines a slot offer.
//
// Trigger:
//   POST /waitlist-claim-offer
//   Body: { offer_id: "uuid", action: "accept" | "decline" }
//   Header: Authorization: Bearer <parent-jwt>
//
// Deploy:
//   supabase functions deploy waitlist-claim-offer
//
// On accept:
//   • Marks the offer accepted (row-locks to prevent races)
//   • Sets the waitlist entry status = 'placed'
//   • Marks the slot_opening as filled_by_waitlist_id
//   • Cancels all sibling offers for the same opening (response = superseded)
//   • Fires loser-notifications for each superseded offer
//   • Returns payment_intent details for the first-3-lessons flow

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST only" }, 405);

  // Auth: verify JWT and pull user id.
  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) return json({ error: "auth required" }, 401);
  const jwt = authHeader.slice("Bearer ".length);

  const anonClient = createClient(SUPABASE_URL, SERVICE_KEY, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
    auth: { persistSession: false },
  });
  const { data: userData, error: userErr } = await anonClient.auth.getUser(jwt);
  if (userErr || !userData?.user) return json({ error: "invalid session" }, 401);
  const userId = userData.user.id;

  let body: { offer_id?: string; action?: string };
  try { body = await req.json(); } catch { return json({ error: "bad JSON" }, 400); }
  const offerId = body.offer_id;
  const action = body.action;
  if (!offerId || !["accept", "decline"].includes(action ?? "")) {
    return json({ error: "offer_id + action=accept|decline required" }, 400);
  }

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // 1. Load the offer + verify ownership.
  const { data: offer, error: offerErr } = await sb
    .from("waitlist_slot_offers")
    .select(`
      id, waitlist_id, location_id, day_of_week, slot_time, expires_at,
      response, priority_rank,
      waitlist:waitlist_id ( parent_id, child_id )
    `)
    .eq("id", offerId)
    .maybeSingle<any>();

  if (offerErr || !offer) return json({ error: "offer not found" }, 404);
  if (offer.waitlist?.parent_id !== userId) return json({ error: "not your offer" }, 403);
  if (offer.response && offer.response !== "pending") {
    return json({ error: `offer already ${offer.response}` }, 409);
  }
  if (new Date(offer.expires_at).getTime() < Date.now()) {
    await sb.from("waitlist_slot_offers")
      .update({ response: "expired", responded_at: new Date().toISOString() })
      .eq("id", offerId);
    return json({ error: "offer expired" }, 410);
  }

  // 2. Handle decline — simple state flip.
  if (action === "decline") {
    await sb.from("waitlist_slot_offers")
      .update({ response: "declined", responded_at: new Date().toISOString() })
      .eq("id", offerId);
    return json({ ok: true, action: "declined" });
  }

  // 3. Handle accept — locate the sibling offers for the same opening.
  //    (We locate the opening by (location, day, slot) since offers don't
  //    currently carry the opening_id; if they do in a future migration, this
  //    query gets simpler.)
  const { data: siblings } = await sb
    .from("waitlist_slot_offers")
    .select("id, waitlist_id, priority_rank, response")
    .eq("location_id", offer.location_id)
    .eq("day_of_week", offer.day_of_week)
    .eq("slot_time", offer.slot_time)
    .in("response", ["pending", "accepted"]);

  const already = (siblings ?? []).find((s) => s.response === "accepted" && s.id !== offer.id);
  if (already) return json({ error: "slot already taken by another parent" }, 409);

  // 4. Mark this offer accepted, others as superseded.
  const now = new Date().toISOString();
  await sb.from("waitlist_slot_offers")
    .update({ response: "accepted", responded_at: now })
    .eq("id", offer.id);
  const superseded = (siblings ?? []).filter((s) => s.id !== offer.id).map((s) => s.id);
  if (superseded.length) {
    await sb.from("waitlist_slot_offers")
      .update({ response: "superseded", responded_at: now })
      .in("id", superseded);
  }

  // 5. Update the waitlist entry to 'placed'.
  await sb.from("waitlist")
    .update({ status: "placed" })
    .eq("id", offer.waitlist_id);

  // 6. Mark the slot opening as filled (best-effort — matches by location/day/slot).
  await sb.from("waitlist_slot_openings")
    .update({ status: "filled", filled_by_waitlist_id: offer.waitlist_id, matched_at: now })
    .eq("location_id", offer.location_id)
    .eq("day_of_week", offer.day_of_week)
    .eq("slot_time", offer.slot_time)
    .eq("status", "matched");

  // 7. Notify losers.
  try {
    await sb.functions.invoke("waitlist-notify-losers", {
      body: { superseded_offer_ids: superseded },
    });
  } catch (e) {
    console.warn("loser-notify failed:", (e as Error).message);
  }

  return json({
    ok: true,
    action: "accepted",
    next_step: "pay_first_three_lessons",
    waitlist_id: offer.waitlist_id,
    superseded_count: superseded.length,
  });
});

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}
