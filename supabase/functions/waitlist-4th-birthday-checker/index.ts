// Walter 2026-08-16: Daily job that finds children on the general waiting
// list who turn 4 today, congratulates them, and prompts the parent to
// register for the official swimming-lessons list.
//
// Trigger:
//   POST /waitlist-4th-birthday-checker
//
// Deploy:
//   supabase functions deploy waitlist-4th-birthday-checker
//
// Schedule (Supabase dashboard → Edge Functions → Cron):
//   0 8 * * *    (every day at 08:00 UTC — 10:00 NL / 13:00 PKT)

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
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: rows, error } = await sb.rpc("waitlist_children_turning_four_today");
  if (error) return json({ error: error.message }, 500);
  const list = (rows ?? []) as any[];

  const stats = { checked: list.length, notified: 0, statusUpdated: 0 };

  for (const r of list) {
    const parentName = r.parent_first_name ?? "";
    const childName = r.child_first_name ?? "uw kind";
    const title = `🎉 Gefeliciteerd — ${childName} is 4 jaar!`;
    const body = `Uw kind is nu 4 jaar. Wilt u zich registreren voor de officiële zwemlessen? De aanbevolen startleeftijd is 4½–5 jaar.`;

    // Fetch FCM token
    const { data: prof } = await sb
      .from("profiles")
      .select("fcm_token")
      .eq("id", r.parent_id)
      .maybeSingle();

    // Push
    if (FCM_SERVER_KEY && prof?.fcm_token) {
      await sendFcm(prof.fcm_token, title, body, {
        type: "waitlist_4th_birthday",
        waitlist_id: r.waitlist_id,
        child_id: r.child_id,
      });
    }

    // Email
    if (RESEND_API_KEY && r.parent_email) {
      await sendEmail(r.parent_email, title, buildBirthdayEmail({
        parentName, childName, waitlistId: r.waitlist_id,
      }));
    }

    // In-app notification
    await sb.from("notifications").insert({
      user_id: r.parent_id,
      audience: "parent",
      type: "waitlist_4th_birthday",
      title,
      body,
      payload: { waitlist_id: r.waitlist_id, child_id: r.child_id },
    });

    // Flip the entry so admin sees "ready for official registration"
    await sb.from("waitlist")
      .update({ status: "active" })       // was: no_status / pending
      .eq("id", r.waitlist_id);

    stats.notified++;
    stats.statusUpdated++;
  }

  return json({ ok: true, ...stats });
});

async function sendFcm(token: string, title: string, body: string, data: Record<string, string>): Promise<void> {
  try {
    await fetch("https://fcm.googleapis.com/fcm/send", {
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
  } catch (e) {
    console.warn("FCM failed:", (e as Error).message);
  }
}

async function sendEmail(to: string, subject: string, html: string): Promise<void> {
  try {
    await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": `Bearer ${RESEND_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: EMAIL_FROM, to, subject, html }),
    });
  } catch (e) {
    console.warn("Email failed:", (e as Error).message);
  }
}

function buildBirthdayEmail(o: { parentName: string; childName: string; waitlistId: string }): string {
  const url = `${APP_DEEP_LINK}/official-register/${o.waitlistId}`;
  return `
  <div style="font-family: system-ui, sans-serif; max-width: 560px; margin: 0 auto; padding: 24px; color: #1A1A2E;">
    <div style="background: linear-gradient(135deg,#FF5C00,#F5A623); color: white; padding: 24px; border-radius: 12px 12px 0 0;">
      <h1 style="margin: 0; font-size: 24px;">🎉 Gefeliciteerd!</h1>
    </div>
    <div style="background: white; padding: 24px; border-radius: 0 0 12px 12px; border: 1px solid #E8ECF4; border-top: none;">
      <p>Beste ${escapeHtml(o.parentName) || "ouder"},</p>
      <p><b>${escapeHtml(o.childName)}</b> is vandaag 4 jaar geworden — wat een mijlpaal!</p>
      <p>Nu dat ${escapeHtml(o.childName)} 4 is, kunt u zich registreren voor de <b>officiële zwemlessen wachtlijst</b>. De aanbevolen startleeftijd bij Snorkeltje is 4½ tot 5 jaar, dus u heeft nog even de tijd — of u kunt zich vast alvast aanmelden.</p>
      <p><b>Registratie kost éénmalig €30.</b> Uw huidige wachtpositie blijft behouden — de datum waarop u zich op de algemene lijst inschreef telt.</p>
      <p style="text-align: center; margin: 24px 0;">
        <a href="${url}" style="display: inline-block; padding: 12px 24px; background: linear-gradient(135deg,#FF5C00,#F5A623); color: white; text-decoration: none; border-radius: 8px; font-weight: 600;">Registreer voor officiële lessen</a>
      </p>
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
