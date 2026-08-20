// Walter 2026-08-16: Automated waitlist matcher.
//
// Called with an opening_id from waitlist_slot_openings. Runs the SQL matching
// function to find the top-N eligible parents, inserts a 24-hour offer for
// each into waitlist_slot_offers, and fans out FCM push + email invitations.
//
// Trigger:
//   POST /waitlist-match-and-offer
//   Body: { opening_id: "uuid" }
//
// Deploy:
//   supabase functions deploy waitlist-match-and-offer
//
// Called from:
//   • openWaitlistSlot() in web-admin admin-repository.ts
//   • The waitlist-detect-slot function when an instructor marks a child done
//   • The waitlist-expire-offers cron (when a slot needs a re-match)

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

const MAX_OFFERS_PER_SLOT = 10;

interface OpeningRow {
  id: string;
  location_id: string;
  day_of_week: number;
  slot_time: string;
  lesson_type: string;
  status: string;
}

interface CandidateRow {
  waitlist_id: string;
  parent_id: string;
  child_id: string;
  list_type: string;
  general_registration_date: string;
  official_registration_date: string | null;
  priority_rank: number;
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") {
    return json({ error: "POST only" }, 405);
  }

  let opening_id: string | undefined;
  try {
    const body = await req.json();
    opening_id = body?.opening_id;
  } catch { /* fall through */ }
  if (!opening_id) return json({ error: "opening_id required" }, 400);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // 1. Load the opening.
  const { data: opening, error: openErr } = await sb
    .from("waitlist_slot_openings")
    .select("id, location_id, day_of_week, slot_time, lesson_type, status")
    .eq("id", opening_id)
    .maybeSingle<OpeningRow>();

  if (openErr || !opening) {
    return json({ error: `opening not found: ${openErr?.message ?? "missing"}` }, 404);
  }
  if (opening.status !== "pending") {
    return json({ ok: true, note: "opening already processed", status: opening.status });
  }

  // 2. Ask the SQL matcher for prioritised candidates.
  const { data: candidates, error: matchErr } = await sb.rpc("waitlist_match_candidates", {
    p_location_id: opening.location_id,
    p_day_of_week: opening.day_of_week,
    p_slot_time: opening.slot_time,
    p_lesson_type: opening.lesson_type,
    p_limit: MAX_OFFERS_PER_SLOT,
  });
  if (matchErr) return json({ error: `match failed: ${matchErr.message}` }, 500);
  const rows = (candidates ?? []) as CandidateRow[];

  // 3. Nobody eligible → mark opening as no_matches and stop.
  if (!rows.length) {
    await sb
      .from("waitlist_slot_openings")
      .update({ status: "no_matches", matched_at: new Date().toISOString() })
      .eq("id", opening.id);
    return json({ ok: true, offer_count: 0, note: "no eligible parents" });
  }

  // 4. Insert one offer per candidate. 24-hour window.
  const now = new Date();
  const expires = new Date(now.getTime() + 24 * 60 * 60 * 1000);
  const offers = rows.map((c) => ({
    waitlist_id: c.waitlist_id,
    location_id: opening.location_id,
    day_of_week: opening.day_of_week,
    slot_time: opening.slot_time,
    offered_at: now.toISOString(),
    expires_at: expires.toISOString(),
    response: "pending",
    priority_rank: c.priority_rank,
  }));

  const { data: insertedOffers, error: insertErr } = await sb
    .from("waitlist_slot_offers")
    .insert(offers)
    .select("id, waitlist_id, priority_rank");

  if (insertErr) return json({ error: `offer insert failed: ${insertErr.message}` }, 500);

  // 5. Flip the opening to matched.
  await sb
    .from("waitlist_slot_openings")
    .update({ status: "matched", matched_at: now.toISOString() })
    .eq("id", opening.id);

  // 6. Fan out notifications (best-effort, do not block on failure).
  const offerIds = (insertedOffers ?? []).map((o) => o.id as string);
  try {
    await sb.functions.invoke("waitlist-send-notifications", {
      body: { offer_ids: offerIds, opening_id: opening.id },
    });
  } catch (e) {
    console.warn("notification dispatch failed:", (e as Error).message);
  }

  return json({
    ok: true,
    opening_id: opening.id,
    offer_count: offerIds.length,
    expires_at: expires.toISOString(),
    top_candidate: rows[0] ? {
      waitlist_id: rows[0].waitlist_id,
      registration_date: rows[0].general_registration_date,
    } : null,
  });
});

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}
