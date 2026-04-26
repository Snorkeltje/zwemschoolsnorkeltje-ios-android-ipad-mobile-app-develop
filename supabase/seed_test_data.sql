-- Seed data for test users so the app shows realistic per-user content.
-- Parent: ouder@test.nl (id: 17ac2481-b7e9-4685-8d25-ed31dd22c692)
-- Instructor: instructeur@test.nl (id: 6d626012-a1d9-4d64-92da-6f433c757e70)

-- ===== Children for parent =====
INSERT INTO public.children (id, parent_id, first_name, last_name, date_of_birth, level, progress, medical_notes, allergies, emergency_contact, avatar_color)
VALUES
  ('11111111-1111-1111-1111-111111111111', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'Sami', 'Khilji', '2019-03-15', 'Gevorderd Beginner', 72,
   'Geen bijzonderheden', '{}', 'Fatima Khilji · +31 6 87654321', '#0365C4'),
  ('22222222-2222-2222-2222-222222222222', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'Noor', 'Khilji', '2021-08-22', 'Beginner', 35,
   'Astma — inhaler altijd bij zich', '{Pollen}', 'Fatima Khilji · +31 6 87654321', '#FF5C00')
ON CONFLICT (id) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  date_of_birth = EXCLUDED.date_of_birth,
  level = EXCLUDED.level,
  progress = EXCLUDED.progress;

-- ===== Locations (master data — visible to everyone) =====
INSERT INTO public.locations (id, name, city)
VALUES
  ('aaaaaaaa-0001-0000-0000-000000000001', 'De Bilt', 'Utrecht'),
  ('aaaaaaaa-0001-0000-0000-000000000002', 'Bad Hulckesteijn', 'Nijkerk'),
  ('aaaaaaaa-0001-0000-0000-000000000003', 'Garderen', 'Barneveld'),
  ('aaaaaaaa-0001-0000-0000-000000000004', 'Wolfheze', 'Renkum'),
  ('aaaaaaaa-0001-0000-0000-000000000005', 'Ampt v. Nijkerk', 'Nijkerk'),
  ('aaaaaaaa-0001-0000-0000-000000000006', 'Doorwerth', 'Renkum')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- ===== Wallet voucher for parent =====
INSERT INTO public.credit_vouchers (id, parent_id, initial_amount_cents, bonus_cents, current_balance_cents)
VALUES
  ('cccccccc-1111-0000-0000-000000000001', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   20000, 200, 16450)
ON CONFLICT (id) DO UPDATE SET current_balance_cents = EXCLUDED.current_balance_cents;

-- ===== Voucher transactions =====
INSERT INTO public.voucher_transactions (id, voucher_id, amount_cents, description, created_at)
VALUES
  ('dddddddd-1111-0000-0000-000000000001',
   'cccccccc-1111-0000-0000-000000000001',
   20200, 'Tegoed opgewaardeerd via iDEAL', now() - interval '5 days'),
  ('dddddddd-1111-0000-0000-000000000002',
   'cccccccc-1111-0000-0000-000000000001',
   -3900, 'Les van Jan de Vries · 1-op-1', now() - interval '3 days'),
  ('dddddddd-1111-0000-0000-000000000003',
   'cccccccc-1111-0000-0000-000000000001',
   -2800, 'Les van Jan de Vries · 1-op-2', now() - interval '1 day')
ON CONFLICT (id) DO NOTHING;

-- Verify
SELECT 'children' AS what, count(*) FROM public.children WHERE parent_id = '17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL
SELECT 'locations', count(*) FROM public.locations
UNION ALL
SELECT 'voucher_balance_eur', current_balance_cents/100 FROM public.credit_vouchers WHERE parent_id = '17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL
SELECT 'voucher_transactions', count(*) FROM public.voucher_transactions vt
  JOIN public.credit_vouchers v ON v.id = vt.voucher_id
  WHERE v.parent_id = '17ac2481-b7e9-4685-8d25-ed31dd22c692';
