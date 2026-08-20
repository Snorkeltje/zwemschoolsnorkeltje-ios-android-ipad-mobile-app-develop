// Walter 2026-08-16: Expire stale offers + award slots to the highest-priority
// accepter. Runs on a 10-minute cron via Supabase scheduled functions.
//
// Trigger:
//   POST /waitlist-expire-offers   (no body; header only)
//   Header: Authorization: Bearer <service-role-key or scheduler token>
//
// Deploy:
//   supabase functions deploy waitlist-expire-offers
//
// Schedule (Supabase dashboard → Edge Functions → Cron):
//   */10 * * * *   (every 10 minutes)

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

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // The bulk of the work happens inside the SQL function so it's atomic.
  const { data, error } = await sb.rpc("waitlist_expire_stale_offers");
  if (error) return json({ error: error.message }, 500);
  const stats = (data ?? [])[0] ?? { expired_count: 0, filled_slots: 0, released_slots: 0 };

  // For every released opening, re-trigger the matcher so a new round of
  // offers goes out (fresh 24-hour window).
  const { data: released } = await sb
    .from("waitlist_slot_openings")
    .select("id")
    .eq("status", "released");

  let requeued = 0;
  for (const row of released ?? []) {
    // Reset to pending so the matcher will process it again.
    await sb.from("waitlist_slot_openings").update({ status: "pending" }).eq("id", row.id);
    try {
      await sb.functions.invoke("waitlist-match-and-offer", { body: { opening_id: row.id } });
      requeued++;
    } catch (e) {
      console.warn("re-match failed:", (e as Error).message);
    }
  }

  return json({ ok: true, ...stats, requeued });
});

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}
