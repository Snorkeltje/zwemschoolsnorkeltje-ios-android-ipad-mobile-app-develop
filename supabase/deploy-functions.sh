#!/usr/bin/env bash
# One-time deployment of Stripe iDEAL Edge Function.
# Reads STRIPE_SECRET_KEY from supabase/.secrets.local (gitignored).

set -euo pipefail

PROJECT_REF="sjktryrxktsvjscgdquj"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRETS_FILE="${SCRIPT_DIR}/.secrets.local"

if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "❌ ${SECRETS_FILE} missing. Create it with STRIPE_SECRET_KEY=sk_test_..."
  exit 1
fi

# shellcheck disable=SC1090
source "$SECRETS_FILE"

if [[ -z "${STRIPE_SECRET_KEY:-}" ]]; then
  echo "❌ STRIPE_SECRET_KEY not set in ${SECRETS_FILE}"
  exit 1
fi

cd "${SCRIPT_DIR}/.."

echo "🔐 Logging in to Supabase (browser opens)..."
supabase login

echo "🔗 Linking project ${PROJECT_REF}..."
supabase link --project-ref "$PROJECT_REF"

echo "🔑 Setting STRIPE_SECRET_KEY on Supabase..."
supabase secrets set STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY"

echo "🚀 Deploying create-payment-intent..."
supabase functions deploy create-payment-intent --no-verify-jwt

echo ""
echo "✅ Done. Test:"
echo "   curl -X POST https://${PROJECT_REF}.supabase.co/functions/v1/create-payment-intent \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"amount\":200,\"description\":\"test\"}'"
