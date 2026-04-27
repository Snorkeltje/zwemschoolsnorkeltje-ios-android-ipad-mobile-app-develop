-- Comprehensive seed data for both test users.
-- Parent: ouder@test.nl (id: 17ac2481-b7e9-4685-8d25-ed31dd22c692)
-- Instructor: instructeur@test.nl (id: 6d626012-a1d9-4d64-92da-6f433c757e70)

-- ===== Update profile names where missing =====
UPDATE public.profiles SET first_name='Jan', last_name='de Vries' WHERE id='6d626012-a1d9-4d64-92da-6f433c757e70';
UPDATE public.profiles SET first_name='Ahmed', last_name='Khilji' WHERE id='17ac2481-b7e9-4685-8d25-ed31dd22c692';

-- ===== Lessons (instructor schedule for next 14 days) =====
INSERT INTO public.lessons (id, instructor_id, location_id, date, start_time, end_time, type, max_students, price_cents)
VALUES
  -- Today + tomorrow (Monday/Tuesday)
  ('aaaa1111-0000-0000-0000-000000000001', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000001', CURRENT_DATE, '15:00', '15:30', '1-op-1', 1, 3900),
  ('aaaa1111-0000-0000-0000-000000000002', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000001', CURRENT_DATE, '15:30', '16:00', '1-op-2', 2, 2800),
  ('aaaa1111-0000-0000-0000-000000000003', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000001', CURRENT_DATE, '16:00', '16:30', '1-op-3', 3, 2200),
  ('aaaa1111-0000-0000-0000-000000000004', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000003', CURRENT_DATE + 2, '14:00', '14:30', '1-op-1', 1, 3900),
  ('aaaa1111-0000-0000-0000-000000000005', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000002', CURRENT_DATE + 4, '16:00', '16:30', '1-op-2', 2, 2800)
ON CONFLICT (id) DO NOTHING;

-- ===== Reservations (parent's children booked into lessons) =====
INSERT INTO public.reservations (id, lesson_id, child_id, parent_id, status, payment_method, payment_status, amount_cents, confirmed_at)
VALUES
  ('bbbb1111-0000-0000-0000-000000000001', 'aaaa1111-0000-0000-0000-000000000001',
   '11111111-1111-1111-1111-111111111111', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'confirmed', 'credit_voucher', 'paid', 3900, now()),
  ('bbbb1111-0000-0000-0000-000000000002', 'aaaa1111-0000-0000-0000-000000000002',
   '22222222-2222-2222-2222-222222222222', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'confirmed', 'credit_voucher', 'paid', 2800, now()),
  ('bbbb1111-0000-0000-0000-000000000003', 'aaaa1111-0000-0000-0000-000000000004',
   '11111111-1111-1111-1111-111111111111', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'confirmed', 'credit_voucher', 'paid', 3900, now())
ON CONFLICT (id) DO NOTHING;

-- ===== Conversations (parent ↔ instructor) =====
INSERT INTO public.conversations (id, parent_id, instructor_id, child_id, subject, last_message, last_message_at)
VALUES
  ('cccc1111-0000-0000-0000-000000000001',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692', '6d626012-a1d9-4d64-92da-6f433c757e70',
   '11111111-1111-1111-1111-111111111111',
   'Voortgang Sami', 'Bedankt voor de feedback!', now() - interval '2 hours')
ON CONFLICT (id) DO UPDATE SET last_message = EXCLUDED.last_message;

-- ===== Messages =====
INSERT INTO public.messages (id, conversation_id, sender_id, body, created_at)
VALUES
  ('dddd1111-0000-0000-0000-000000000001', 'cccc1111-0000-0000-0000-000000000001',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'Hoi Jan! Hoe ging de les vandaag met Sami?', now() - interval '4 hours'),
  ('dddd1111-0000-0000-0000-000000000002', 'cccc1111-0000-0000-0000-000000000001',
   '6d626012-a1d9-4d64-92da-6f433c757e70',
   'Hoi Ahmed! Het ging echt goed vandaag. Sami heeft 10m vrije slag zonder stoppen gezwommen!', now() - interval '3 hours'),
  ('dddd1111-0000-0000-0000-000000000003', 'cccc1111-0000-0000-0000-000000000001',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'Wauw, wat geweldig! Bedankt voor de feedback!', now() - interval '2 hours')
ON CONFLICT (id) DO NOTHING;

-- ===== Notifications =====
INSERT INTO public.notifications (id, user_id, audience, type, title, body, read, created_at)
VALUES
  ('eeee1111-0000-0000-0000-000000000001', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'parent', 'lesson_reminder', 'Les vandaag', 'Sami heeft les om 15:00 — De Bilt', false, now() - interval '30 minutes'),
  ('eeee1111-0000-0000-0000-000000000002', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'parent', 'progress', 'Voortgang Sami!', 'Niveau gestegen naar Gevorderd Beginner', false, now() - interval '1 day'),
  ('eeee1111-0000-0000-0000-000000000003', '17ac2481-b7e9-4685-8d25-ed31dd22c692',
   'parent', 'message', 'Nieuw bericht', 'Jan de Vries heeft gereageerd', true, now() - interval '2 days'),
  ('eeee1111-0000-0000-0000-000000000004', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'instructor', 'schedule', 'Rooster wijziging', 'Sami Khilji verplaatst van 15:00 naar 15:30', false, now() - interval '15 minutes'),
  ('eeee1111-0000-0000-0000-000000000005', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'instructor', 'admin', 'Bericht van het Snorkeltje team', 'Nieuwe lesplan update voor Diploma B', false, now() - interval '1 hour')
ON CONFLICT (id) DO NOTHING;

-- ===== Reviews (a few public ones + 1 with owner response) =====
INSERT INTO public.reviews (id, parent_id, instructor_id, location_id, rating, text, helpful_count, owner_response, published, responded_at, created_at)
VALUES
  ('ffff1111-0000-0000-0000-000000000001',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000001',
   10, 'Fantastische zwemles! Sami heeft enorme vooruitgang.', 24, NULL, true, NULL, now() - interval '14 days'),
  ('ffff1111-0000-0000-0000-000000000002',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000001',
   9, 'Persoonlijke aanpak, kinderen gaan met plezier.', 18, NULL, true, NULL, now() - interval '30 days'),
  ('ffff1111-0000-0000-0000-000000000003',
   '17ac2481-b7e9-4685-8d25-ed31dd22c692', '6d626012-a1d9-4d64-92da-6f433c757e70',
   'aaaaaaaa-0001-0000-0000-000000000003',
   5, 'Les werd te vaak verplaatst.', 3,
   'Dank voor uw feedback! De planning is sinds januari aangepast — minder wijzigingen.',
   true, now() - interval '13 days', now() - interval '14 days')
ON CONFLICT (id) DO NOTHING;

-- ===== Skills (curriculum) =====
INSERT INTO public.skills (id, name, level, description, sort_order)
VALUES
  ('11111111-aaaa-0000-0000-000000000001', 'Vrije slag armen', 'Beginner', 'Basis armcoördinatie', 1),
  ('11111111-aaaa-0000-0000-000000000002', 'Ademhaling', 'Beginner', 'Beheersen van uitademen onder water', 2),
  ('11111111-aaaa-0000-0000-000000000003', 'Drijven op rug', 'Beginner', 'Stabiel op rug blijven', 3),
  ('11111111-aaaa-0000-0000-000000000004', 'Rugslag', 'Gevorderd Beginner', 'Volledige rugslag 10m', 4),
  ('11111111-aaaa-0000-0000-000000000005', 'Schoolslag benen', 'Gevorderd', 'Correcte beenslag', 5),
  ('11111111-aaaa-0000-0000-000000000006', 'Diploma A vaardigheden', 'Diploma A', 'Alle A-eisen', 6)
ON CONFLICT (id) DO NOTHING;

-- ===== Child skills progress =====
INSERT INTO public.child_skills (id, child_id, skill_id, progress_pct, steps_completed)
VALUES
  ('22222222-aaaa-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
   '11111111-aaaa-0000-0000-000000000001', 100, 5),
  ('22222222-aaaa-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111',
   '11111111-aaaa-0000-0000-000000000002', 80, 4),
  ('22222222-aaaa-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111',
   '11111111-aaaa-0000-0000-000000000004', 45, 2)
ON CONFLICT (id) DO NOTHING;

-- ===== Verify =====
SELECT 'children'                AS what, count(*) FROM public.children WHERE parent_id='17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL SELECT 'lessons',                count(*) FROM public.lessons WHERE instructor_id='6d626012-a1d9-4d64-92da-6f433c757e70'
UNION ALL SELECT 'reservations',           count(*) FROM public.reservations WHERE parent_id='17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL SELECT 'conversations',          count(*) FROM public.conversations WHERE parent_id='17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL SELECT 'messages',               count(*) FROM public.messages WHERE conversation_id='cccc1111-0000-0000-0000-000000000001'
UNION ALL SELECT 'notifications_parent',   count(*) FROM public.notifications WHERE user_id='17ac2481-b7e9-4685-8d25-ed31dd22c692'
UNION ALL SELECT 'notifications_instr',    count(*) FROM public.notifications WHERE user_id='6d626012-a1d9-4d64-92da-6f433c757e70'
UNION ALL SELECT 'reviews',                count(*) FROM public.reviews
UNION ALL SELECT 'skills',                 count(*) FROM public.skills
UNION ALL SELECT 'child_skills',           count(*) FROM public.child_skills;
