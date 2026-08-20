// Walter 2026-08-16: Detect a freed lesson slot and open the matching flow.
//
// Called by the instructor UI when they mark a child as "Diploma B completed"
// or "Left program", or by the admin panel manually.
//
// Trigger:
//   POST /waitlist-detect-slot
//   Header: Authorization: Bearer <instructor-or-admin-jwt>
//   Body:
//     {
//       location_id: "uuid",
//       day_of_week: 0..6,
//       slot_time: "HH:MM",
//       lesson_type: "one_on_one" | ...,
//       freed_by_child_id?: "uuid",
//       freed_reason?: "diploma_b_completed" | "left_program" | "manual_admin" | "cancellation",
//       notes?: string
//     }
//
// Deploy:
//   supabase functions deploy waitlist-detect-slot

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

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) return json({ error: "auth required" }, 401);
  const jwt = authHeader.slice("Bearer ".length);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // Verify the caller is an admin or instructor.
  const { data: userData, error: userErr } = await sb.auth.getUser(jwt);
  if (userErr || !userData?.user) return json({ error: "invalid session" }, 401);
  const { data: profile } = await sb
    .from("profiles")
    .select("role")
    .eq("id", userData.user.id)
    .maybeSingle();
  if (!profile || !["admin", "instructor"].includes(profile.role as string)) {
    return json({ error: "admins/instructors only" }, 403);
  }

  let body: any;
  try { body = await req.json(); } catch { return json({ error: "bad JSON" }, 400); }
  const { location_id, day_of_week, slot_time, lesson_type,
          freed_by_child_id, freed_reason, notes } = body ?? {};

  if (!location_id || day_of_week === undefined || !slot_time || !lesson_type) {
    return json({ error: "location_id, day_of_week, slot_time, lesson_type required" }, 400);
  }

  // Insert via the SQL wrapper so triggers and defaults run.
  const { data: openingId, error: rpcErr } = await sb.rpc("waitlist_open_slot", {
    p_location_id: location_id,
    p_day_of_week: day_of_week,
    p_slot_time: slot_time,
    p_lesson_type: lesson_type,
    p_freed_by_child_id: freed_by_child_id ?? null,
    p_freed_reason: freed_reason ?? "manual_admin",
    p_notes: notes ?? null,
  });
  if (rpcErr) return json({ error: `open_slot failed: ${rpcErr.message}` }, 500);

  // Fire the matcher immediately (best-effort — the expiry cron will retry).
  try {
    await sb.functions.invoke("waitlist-match-and-offer", {
      body: { opening_id: openingId },
    });
  } catch (e) {
    console.warn("matcher invoke failed:", (e as Error).message);
  }

  return json({ ok: true, opening_id: openingId });
});

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}
