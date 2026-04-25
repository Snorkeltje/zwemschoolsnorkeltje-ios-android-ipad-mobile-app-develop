// Supabase Edge Function — Stripe PaymentIntent creation.
// Called from the mobile app to get a client_secret for iDEAL payments.
// The Stripe secret key NEVER leaves the server.
//
// Deploy: supabase functions deploy create-payment-intent
// Set secret: supabase secrets set STRIPE_SECRET_KEY=sk_test_...

// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const STRIPE_SECRET = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface Body {
  amount: number;            // in euro (e.g. 39, 200) — converted to cents
  currency?: string;         // default 'eur'
  payment_method_types?: string[]; // default ['ideal']
  description?: string;
  metadata?: Record<string, string>;
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "POST only" }), { status: 405, headers: CORS });
  }
  if (!STRIPE_SECRET) {
    return new Response(JSON.stringify({ error: "STRIPE_SECRET_KEY not configured" }), {
      status: 500, headers: { ...CORS, "Content-Type": "application/json" },
    });
  }

  try {
    const body = (await req.json()) as Body;
    if (!body.amount || body.amount <= 0) {
      return new Response(JSON.stringify({ error: "amount required" }), {
        status: 400, headers: { ...CORS, "Content-Type": "application/json" },
      });
    }

    const cents = Math.round(body.amount * 100);
    const currency = body.currency ?? "eur";
    const methods = body.payment_method_types ?? ["ideal"];
    const description = body.description ?? "Zwemschool Snorkeltje";

    const form = new URLSearchParams();
    form.set("amount", String(cents));
    form.set("currency", currency);
    methods.forEach((m, i) => form.set(`payment_method_types[${i}]`, m));
    form.set("description", description);
    if (body.metadata) {
      for (const [k, v] of Object.entries(body.metadata)) {
        form.set(`metadata[${k}]`, v);
      }
    }

    const stripeRes = await fetch("https://api.stripe.com/v1/payment_intents", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${STRIPE_SECRET}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: form.toString(),
    });

    const data = await stripeRes.json();
    if (!stripeRes.ok) {
      return new Response(JSON.stringify({ error: data.error?.message ?? "Stripe error", details: data }), {
        status: stripeRes.status, headers: { ...CORS, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({
      client_secret: data.client_secret,
      payment_intent_id: data.id,
      amount: data.amount,
      currency: data.currency,
      status: data.status,
    }), { status: 200, headers: { ...CORS, "Content-Type": "application/json" } });
  } catch (e: any) {
    return new Response(JSON.stringify({ error: e?.message ?? "unknown" }), {
      status: 500, headers: { ...CORS, "Content-Type": "application/json" },
    });
  }
});
