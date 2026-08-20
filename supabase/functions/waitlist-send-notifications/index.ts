// Walter 2026-08-16: Fan out FCM push + email to every parent who just
// received a slot offer.
//
// Trigger:
//   POST /waitlist-send-notifications
//   Body: { offer_ids: ["uuid", ...], opening_id: "uuid" }
//
// Deploy:
//   supabase functions deploy waitlist-send-notifications
//
// Environment required:
//   • FCM_SERVER_KEY  — Firebase Cloud Messaging legacy server key
//   • RESEND_API_KEY  — Resend API key (or swap for another mailer)
//   • EMAIL_FROM      — e.g. "no-reply@zwemschoolsnorkeltje.nl"

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY") ?? "";
const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") ?? "";
const EMAIL_FROM = Deno.env.get("EMAIL_FROM") ?? "no-reply@zwemschoolsnorkeltje.nl";
const APP_DEEP_LINK = Deno.env.get("APP_DEEP_LINK") ?? "https://zwemschoolsnorkeltje.nl/app/waitlist";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const DAY_NAMES_NL = ["Zondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag"];

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST only" }, 405);

  let offer_ids: string[] = [];
  let opening_id: string | undefined;
  try {
    const body = await req.json();
    offer_ids = Array.isArray(body?.offer_ids) ? body.offer_ids : [];
    opening_id = body?.opening_id;
  } catch { /* ignore */ }

  if (!offer_ids.length) return json({ error: "offer_ids required" }, 400);

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // Load offer + parent + child + location context in one join.
  const { data: offers } = await sb
    .from("waitlist_slot_offers")
    .select(`
      id, waitlist_id, day_of_week, slot_time, expires_at, priority_rank,
      locations:location_id ( name ),
      waitlist:waitlist_id (
        parent_id,
        profiles:parent_id ( first_name, last_name, email, fcm_token, language ),
        children:child_id ( first_name )
      )
    `)
    .in("id", offer_ids);

  const rows = (offers ?? []) as any[];
  const stats = { pushSent: 0, pushFailed: 0, emailSent: 0, emailFailed: 0 };

  for (const o of rows) {
    const p = o?.waitlist?.profiles ?? {};
    const c = o?.waitlist?.children ?? {};
    const loc = o?.locations ?? {};
    const dayLabel = DAY_NAMES_NL[o.day_of_week] ?? "";
    const slotLabel = `${dayLabel} ${(o.slot_time ?? "").slice(0, 5)}`;
    const title = "Er is een plek vrij!";
    const body = `Voor ${c.first_name ?? "uw kind"} op ${slotLabel} bij ${loc.name ?? "Snorkeltje"}. U heeft 24 uur om te reageren.`;

    // Push (FCM legacy — swap for HTTP v1 later if desired).
    if (FCM_SERVER_KEY && p.fcm_token) {
      const ok = await sendFcm(p.fcm_token, title, body, {
        offer_id: o.id,
        opening_id: opening_id ?? "",
        type: "waitlist_offer",
      });
      ok ? stats.pushSent++ : stats.pushFailed++;
    }

    // Email
    if (RESEND_API_KEY && p.email) {
      const ok = await sendEmail(
        p.email,
        title,
        buildOfferEmail({
          parentFirstName: p.first_name ?? "",
          childFirstName: c.first_name ?? "",
          locationName: loc.name ?? "Snorkeltje",
          slotLabel,
          offerId: o.id,
          priorityRank: o.priority_rank,
          expiresAt: o.expires_at,
        }),
      );
      ok ? stats.emailSent++ : stats.emailFailed++;
    }

    // Log to notifications table so the parent app can show it on the bell.
    await sb.from("notifications").insert({
      user_id: o.waitlist.parent_id,
      audience: "parent",
      type: "waitlist_offer",
      title,
      body,
      payload: {
        offer_id: o.id,
        opening_id: opening_id ?? null,
        slot_time: o.slot_time,
        day_of_week: o.day_of_week,
        expires_at: o.expires_at,
      },
    });
  }

  return json({ ok: true, dispatched: rows.length, ...stats });
});

async function sendFcm(token: string, title: string, body: string, data: Record<string, string>): Promise<boolean> {
  try {
    const res = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Authorization": `key=${FCM_SERVER_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        to: token,
        notification: { title, body, sound: "default" },
        data,
        priority: "high",
      }),
    });
    return res.ok;
  } catch (e) {
    console.warn("FCM send failed:", (e as Error).message);
    return false;
  }
}

async function sendEmail(to: string, subject: string, html: string): Promise<boolean> {
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ from: EMAIL_FROM, to, subject, html }),
    });
    return res.ok;
  } catch (e) {
    console.warn("Email send failed:", (e as Error).message);
    return false;
  }
}

function buildOfferEmail(o: {
  parentFirstName: string;
  childFirstName: string;
  locationName: string;
  slotLabel: string;
  offerId: string;
  priorityRank: number;
  expiresAt: string;
}): string {
  const acceptUrl = `${APP_DEEP_LINK}/accept/${o.offerId}`;
  const declineUrl = `${APP_DEEP_LINK}/decline/${o.offerId}`;
  const expiresPretty = new Date(o.expiresAt).toLocaleString("nl-NL", { dateStyle: "long", timeStyle: "short" });
  return `
  <div style="font-family: system-ui, sans-serif; max-width: 560px; margin: 0 auto; padding: 24px; color: #1A1A2E;">
    <div style="background: linear-gradient(135deg,#0365C4,#00C1FF); color: white; padding: 24px; border-radius: 12px 12px 0 0;">
      <h1 style="margin: 0; font-size: 22px;">🏊 Er is een plek vrij!</h1>
    </div>
    <div style="background: white; padding: 24px; border-radius: 0 0 12px 12px; border: 1px solid #E8ECF4; border-top: none;">
      <p>Beste ${escapeHtml(o.parentFirstName) || "ouder"},</p>
      <p>Er is een zwemles-plek beschikbaar voor <b>${escapeHtml(o.childFirstName) || "uw kind"}</b>:</p>
      <div style="background: #F8FAFC; padding: 16px; border-radius: 8px; margin: 16px 0;">
        <p style="margin: 4px 0;"><b>Locatie:</b> ${escapeHtml(o.locationName)}</p>
        <p style="margin: 4px 0;"><b>Tijdslot:</b> ${escapeHtml(o.slotLabel)}</p>
        <p style="margin: 4px 0;"><b>Uw positie:</b> #${o.priorityRank}</p>
        <p style="margin: 4px 0;"><b>Reageer voor:</b> ${escapeHtml(expiresPretty)}</p>
      </div>
      <p>U heeft <b>24 uur</b> de tijd om te reageren. De plek gaat naar de ouder met de langste wachttijd die accepteert.</p>
      <p style="text-align: center; margin: 24px 0;">
        <a href="${acceptUrl}" style="display: inline-block; padding: 12px 24px; background: linear-gradient(135deg,#FF5C00,#F5A623); color: white; text-decoration: none; border-radius: 8px; font-weight: 600;">Accepteren</a>
        &nbsp;
        <a href="${declineUrl}" style="display: inline-block; padding: 12px 24px; background: #F0F4FA; color: #6B7B94; text-decoration: none; border-radius: 8px; font-weight: 600;">Afwijzen</a>
      </p>
      <p style="font-size: 12px; color: #6B7B94;">Deze uitnodiging is uniek voor u. Deel de link niet.</p>
      <hr style="border: none; border-top: 1px solid #E8ECF4; margin: 24px 0;">
      <p style="font-size: 12px; color: #A0AEC0; text-align: center;">Met vriendelijke groet,<br>Zwemschool Snorkeltje</p>
    </div>
  </div>`;
}

function escapeHtml(s: string): string {
  return String(s ?? "").replace(/[&<>"']/g, (ch) => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;", "'": "&#39;",
  }[ch] ?? ch));
}

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}
