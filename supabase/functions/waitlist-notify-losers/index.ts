// Walter 2026-08-16: Notify parents whose offer was superseded because
// another parent (higher priority) accepted the same slot first.
//
// Called from waitlist-claim-offer when the winner accepts.

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY") ?? "";
const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") ?? "";
const EMAIL_FROM = Deno.env.get("EMAIL_FROM") ?? "no-reply@zwemschoolsnorkeltje.nl";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST only" }, 405);

  let ids: string[] = [];
  try {
    const body = await req.json();
    ids = Array.isArray(body?.superseded_offer_ids) ? body.superseded_offer_ids : [];
  } catch { /* ignore */ }
  if (!ids.length) return json({ ok: true, note: "nothing to notify" });

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: offers } = await sb
    .from("waitlist_slot_offers")
    .select(`
      id, waitlist_id, day_of_week, slot_time,
      locations:location_id ( name ),
      waitlist:waitlist_id (
        parent_id,
        profiles:parent_id ( first_name, email, fcm_token ),
        children:child_id ( first_name )
      )
    `)
    .in("id", ids);

  const stats = { pushSent: 0, emailSent: 0 };
  for (const o of (offers ?? []) as any[]) {
    const p = o?.waitlist?.profiles ?? {};
    const c = o?.waitlist?.children ?? {};
    const loc = o?.locations ?? {};
    const title = "Deze keer geen plek";
    const body = `De vrijgekomen plek bij ${loc.name ?? "Snorkeltje"} is toegewezen aan de langst wachtende ouder. Uw wachtpositie blijft ongewijzigd — u krijgt automatisch de volgende uitnodiging.`;

    if (FCM_SERVER_KEY && p.fcm_token) {
      const ok = await sendFcm(p.fcm_token, title, body);
      if (ok) stats.pushSent++;
    }
    if (RESEND_API_KEY && p.email) {
      const ok = await sendEmail(p.email, title, buildEmail({
        parentName: p.first_name ?? "",
        childName: c.first_name ?? "uw kind",
        locationName: loc.name ?? "Snorkeltje",
      }));
      if (ok) stats.emailSent++;
    }
    // In-app bell
    await sb.from("notifications").insert({
      user_id: o.waitlist.parent_id,
      audience: "parent",
      type: "waitlist_not_selected",
      title, body,
      payload: { offer_id: o.id },
    });
  }

  return json({ ok: true, ...stats, count: (offers ?? []).length });
});

async function sendFcm(token: string, title: string, body: string): Promise<boolean> {
  try {
    const res = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: { "Authorization": `key=${FCM_SERVER_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        to: token,
        notification: { title, body, sound: "default" },
        priority: "high",
      }),
    });
    return res.ok;
  } catch { return false; }
}

async function sendEmail(to: string, subject: string, html: string): Promise<boolean> {
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": `Bearer ${RESEND_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: EMAIL_FROM, to, subject, html }),
    });
    return res.ok;
  } catch { return false; }
}

function buildEmail(o: { parentName: string; childName: string; locationName: string }): string {
  return `
  <div style="font-family: system-ui, sans-serif; max-width: 560px; margin: 0 auto; padding: 24px; color: #1A1A2E;">
    <div style="background: #F8FAFC; padding: 24px; border-radius: 12px 12px 0 0; border: 1px solid #E8ECF4;">
      <h1 style="margin: 0; font-size: 20px; color: #1A1A2E;">Deze keer geen plek</h1>
    </div>
    <div style="background: white; padding: 24px; border-radius: 0 0 12px 12px; border: 1px solid #E8ECF4; border-top: none;">
      <p>Beste ${escape(o.parentName) || "ouder"},</p>
      <p>De vrijgekomen zwemles-plek bij <b>${escape(o.locationName)}</b> is deze keer toegewezen aan de langst-wachtende ouder.</p>
      <p><b>${escape(o.childName)} blijft op uw huidige positie</b> op de wachtlijst. Zodra er weer een passende plek vrijkomt, ontvangt u automatisch de volgende uitnodiging.</p>
      <p style="font-size: 12px; color: #6B7B94;">Dank voor uw begrip — we doen ons best om elk kind zo snel mogelijk een plek te geven.</p>
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
