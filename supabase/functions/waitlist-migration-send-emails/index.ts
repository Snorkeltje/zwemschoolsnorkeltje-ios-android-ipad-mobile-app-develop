// Walter 2026-08-16: Send migration-confirmation emails for the 1,236 legacy
// waiting-list entries imported from i-Reserve. Each parent gets one unique
// link (based on the confirmation_token) — clicking it activates their
// preserved wait position in the new system.
//
// Called two ways:
//   1. Bulk: POST { batch: "2026-08-16-import-01" } → sends all pending in batch
//   2. Single: POST { migration_log_id: "uuid" } → resend to one parent

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") ?? "";
const EMAIL_FROM = Deno.env.get("EMAIL_FROM") ?? "no-reply@zwemschoolsnorkeltje.nl";
const APP_BASE = Deno.env.get("APP_BASE_URL") ?? "https://web-admin-topaz-five.vercel.app";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface MigrationRow {
  id: string;
  email: string;
  parent_name: string | null;
  child_name: string | null;
  original_registration_date: string;
  waitlist_id: string | null;
  status: string;
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST only" }, 405);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  let body: { batch?: string; migration_log_id?: string } = {};
  try { body = await req.json(); } catch { /* empty body ok for bulk-all */ }

  let query = sb
    .from("waitlist_migration_log")
    .select("id, email, parent_name, child_name, original_registration_date, waitlist_id, status")
    .in("status", ["imported", "email_sent"]);
  if (body.migration_log_id) query = query.eq("id", body.migration_log_id);
  else if (body.batch) query = query.eq("migration_batch", body.batch);
  else query = query.limit(500); // safety cap for one invocation

  const { data: rows, error } = await query;
  if (error) return json({ error: error.message }, 500);

  const stats = { sent: 0, failed: 0 };
  for (const r of (rows ?? []) as MigrationRow[]) {
    // Fetch the confirmation_token from waitlist row (that's where we stored it)
    if (!r.waitlist_id) { stats.failed++; continue; }
    const { data: w } = await sb
      .from("waitlist")
      .select("confirmation_token")
      .eq("id", r.waitlist_id)
      .maybeSingle();
    const token = w?.confirmation_token as string | undefined;
    if (!token) { stats.failed++; continue; }

    const ok = await sendEmail(r.email, "Bevestig uw plek op de nieuwe wachtlijst", buildEmail({
      parentName: r.parent_name ?? "",
      childName: r.child_name ?? "uw kind",
      originalDate: r.original_registration_date,
      confirmUrl: `${APP_BASE}/waitlist-confirm/${token}`,
    }));
    if (ok) {
      await sb.from("waitlist_migration_log").update({
        status: "email_sent",
        email_sent_at: new Date().toISOString(),
      }).eq("id", r.id);
      stats.sent++;
    } else {
      await sb.from("waitlist_migration_log").update({
        status: "failed",
        error_message: "email dispatch failed",
      }).eq("id", r.id);
      stats.failed++;
    }
  }

  return json({ ok: true, ...stats, total: (rows ?? []).length });
});

async function sendEmail(to: string, subject: string, html: string): Promise<boolean> {
  if (!RESEND_API_KEY) return false;
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": `Bearer ${RESEND_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: EMAIL_FROM, to, subject, html }),
    });
    return res.ok;
  } catch { return false; }
}

function buildEmail(o: { parentName: string; childName: string; originalDate: string; confirmUrl: string }): string {
  const dt = new Date(o.originalDate).toLocaleDateString("nl-NL", { day: "numeric", month: "long", year: "numeric" });
  return `
  <div style="font-family: system-ui, sans-serif; max-width: 560px; margin: 0 auto; padding: 24px; color: #1A1A2E;">
    <div style="background: linear-gradient(135deg,#0365C4,#00C1FF); color: white; padding: 24px; border-radius: 12px 12px 0 0;">
      <h1 style="margin: 0; font-size: 22px;">🏊 Nieuwe wachtlijst — bevestig uw plek</h1>
    </div>
    <div style="background: white; padding: 24px; border-radius: 0 0 12px 12px; border: 1px solid #E8ECF4; border-top: none;">
      <p>Beste ${escape(o.parentName) || "ouder"},</p>
      <p>Zwemschool Snorkeltje is overgestapt op een nieuw wachtlijst-systeem. Uw huidige plek voor <b>${escape(o.childName)}</b> is behouden, maar we hebben één klik van u nodig om deze te bevestigen.</p>
      <div style="background: #F8FAFC; padding: 16px; border-radius: 8px; margin: 16px 0;">
        <p style="margin: 4px 0;"><b>Kind:</b> ${escape(o.childName)}</p>
        <p style="margin: 4px 0;"><b>Oorspronkelijke registratiedatum:</b> ${escape(dt)}</p>
        <p style="margin: 4px 0; color: #10B981; font-weight: 600;">✓ Uw oorspronkelijke wachtdatum blijft behouden</p>
      </div>
      <p style="text-align: center; margin: 24px 0;">
        <a href="${o.confirmUrl}" style="display: inline-block; padding: 14px 28px; background: linear-gradient(135deg,#FF5C00,#F5A623); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 15px;">Bevestig mijn plek</a>
      </p>
      <p style="font-size: 12px; color: #6B7B94;">
        <b>Belangrijk:</b> Zonder bevestiging binnen 30 dagen vervalt de plek. Deze link is uniek voor u — deel hem niet.
      </p>
      <hr style="border: none; border-top: 1px solid #E8ECF4; margin: 24px 0;">
      <p style="font-size: 12px; color: #A0AEC0; text-align: center;">Met vriendelijke groet,<br>Zwemschool Snorkeltje</p>
    </div>
  </div>`;
}
function escape(s: string): string {
  return String(s ?? "").replace(/[&<>"']/g, (c) => ({
    "&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;",
  }[c] ?? c));
}
function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status, headers: { ...CORS, "Content-Type": "application/json" },
  });
}
