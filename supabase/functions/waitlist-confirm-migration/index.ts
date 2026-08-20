// Walter 2026-08-16: Confirm a migrated waitlist entry when the parent clicks
// the unique link in their migration email. Preserves original registration
// date so their wait position doesn't move.

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  let token: string | undefined;
  if (req.method === "GET") {
    // Support GET so email links work directly.
    const url = new URL(req.url);
    token = url.searchParams.get("token") ?? undefined;
  } else {
    try {
      const body = await req.json();
      token = body?.confirmation_token;
    } catch { /* ignore */ }
  }
  if (!token) return json({ error: "confirmation_token required" }, 400);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // 1. Look up the waitlist row by token.
  const { data: entry, error: eerr } = await sb
    .from("waitlist")
    .select("id, confirmation_status, parent_id, child_id, general_registration_date")
    .eq("confirmation_token", token)
    .maybeSingle();
  if (eerr || !entry) return json({ error: "invalid token" }, 404);

  if (entry.confirmation_status === "confirmed") {
    return json({ ok: true, already_confirmed: true, waitlist_id: entry.id });
  }
  if (entry.confirmation_status === "expired") {
    return json({ error: "confirmation window has closed" }, 410);
  }

  // 2. Flip to confirmed. general_registration_date is NEVER changed —
  //    the trigger enforces this even if we tried.
  await sb.from("waitlist").update({
    confirmation_status: "confirmed",
    status: "active",
  }).eq("id", entry.id);

  // 3. Mirror the change into migration_log (best-effort).
  await sb.from("waitlist_migration_log").update({
    status: "confirmed",
    confirmation_clicked_at: new Date().toISOString(),
  }).eq("waitlist_id", entry.id);

  // 4. Send an in-app notification confirming success.
  await sb.from("notifications").insert({
    user_id: entry.parent_id,
    audience: "parent",
    type: "waitlist_confirmed",
    title: "Wachtlijst bevestigd",
    body: "Uw plek op de nieuwe wachtlijst is bevestigd. Uw oorspronkelijke wachtdatum is behouden.",
    payload: { waitlist_id: entry.id },
  });

  return json({
    ok: true,
    waitlist_id: entry.id,
    original_date: entry.general_registration_date,
  });
});

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status, headers: { ...CORS, "Content-Type": "application/json" },
  });
}
