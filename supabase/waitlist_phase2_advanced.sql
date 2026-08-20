-- ═══════════════════════════════════════════════════════════════════════════
--  PHASE 2 ADVANCED — Automated Waiting List System (final layer)
--
--  Run AFTER seed_waitlist_phase2.sql. Adds the missing pieces needed for
--  full automation: slot-opening queue, migration tracking, lesson-type
--  catalog per location, insert-time triggers, and helper functions.
--
--  Idempotent: safe to re-run.
-- ═══════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────────
--  HELPER: auth_user_role() — used by every RLS policy below.
--  Returns the current caller's profiles.role, or 'anonymous' when no session.
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.auth_user_role()
RETURNS text
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (SELECT role::text FROM public.profiles WHERE id = auth.uid()),
    'anonymous'
  );
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  SLOT OPENINGS QUEUE
--  When an instructor marks a student done, a row lands here and the
--  waitlist-match-and-offer edge function picks it up.
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.waitlist_slot_openings (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  location_id uuid NOT NULL REFERENCES public.locations(id),
  day_of_week smallint NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  slot_time time NOT NULL,
  lesson_type text NOT NULL,
  freed_by_child_id uuid REFERENCES public.children(id),
  freed_reason text CHECK (freed_reason IN ('diploma_b_completed', 'left_program', 'manual_admin', 'cancellation')),
  detected_at timestamptz DEFAULT now(),
  matched_at timestamptz,
  status text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'matched', 'filled', 'no_matches', 'released')),
  filled_by_waitlist_id uuid REFERENCES public.waitlist(id),
  notes text
);

CREATE INDEX IF NOT EXISTS idx_slot_openings_status ON public.waitlist_slot_openings (status);
CREATE INDEX IF NOT EXISTS idx_slot_openings_location ON public.waitlist_slot_openings (location_id);
CREATE INDEX IF NOT EXISTS idx_slot_openings_detected ON public.waitlist_slot_openings (detected_at);

ALTER TABLE public.waitlist_slot_openings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "slot_openings_admin" ON public.waitlist_slot_openings;
CREATE POLICY "slot_openings_admin" ON public.waitlist_slot_openings FOR ALL TO authenticated
  USING (public.auth_user_role() IN ('admin', 'instructor'))
  WITH CHECK (public.auth_user_role() IN ('admin', 'instructor'));

-- ────────────────────────────────────────────────────────────────────────────
--  MIGRATION LOG — tracks the 1,236 legacy i-Reserve entries import
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.waitlist_migration_log (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  legacy_id text,                          -- original i-Reserve row id
  waitlist_id uuid REFERENCES public.waitlist(id) ON DELETE SET NULL,
  email text NOT NULL,
  parent_name text,
  child_name text,
  original_registration_date timestamptz NOT NULL,
  migration_batch text NOT NULL,           -- e.g. '2026-08-16-import-01'
  email_sent_at timestamptz,
  email_opened_at timestamptz,
  confirmation_clicked_at timestamptz,
  status text NOT NULL DEFAULT 'imported'
    CHECK (status IN ('imported', 'email_sent', 'confirmed', 'expired', 'failed')),
  error_message text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_migration_log_status ON public.waitlist_migration_log (status);
CREATE INDEX IF NOT EXISTS idx_migration_log_email ON public.waitlist_migration_log (email);
CREATE INDEX IF NOT EXISTS idx_migration_log_batch ON public.waitlist_migration_log (migration_batch);

ALTER TABLE public.waitlist_migration_log ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "migration_log_admin" ON public.waitlist_migration_log;
CREATE POLICY "migration_log_admin" ON public.waitlist_migration_log FOR ALL TO authenticated
  USING (public.auth_user_role() = 'admin')
  WITH CHECK (public.auth_user_role() = 'admin');

-- ────────────────────────────────────────────────────────────────────────────
--  LESSON TYPES CATALOG PER LOCATION
--  Some locations only offer 1-op-1; some offer everything. Admin can toggle.
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.location_lesson_types (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  location_id uuid NOT NULL REFERENCES public.locations(id) ON DELETE CASCADE,
  lesson_type text NOT NULL,
  -- 'no_preference', 'one_on_one', 'one_in_two', 'one_in_two_own_couple',
  -- 'one_in_three', 'one_in_three_own_couple', 'one_in_four', 'one_in_five',
  -- 'baarn_one_in_six', 'survival_swimming'
  price_cents int NOT NULL DEFAULT 0,
  enabled boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  UNIQUE (location_id, lesson_type)
);

CREATE INDEX IF NOT EXISTS idx_location_lesson_types_loc ON public.location_lesson_types (location_id);

ALTER TABLE public.location_lesson_types ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "location_lesson_types_read_all" ON public.location_lesson_types;
CREATE POLICY "location_lesson_types_read_all" ON public.location_lesson_types FOR SELECT TO authenticated
  USING (true);
DROP POLICY IF EXISTS "location_lesson_types_admin_write" ON public.location_lesson_types;
CREATE POLICY "location_lesson_types_admin_write" ON public.location_lesson_types FOR ALL TO authenticated
  USING (public.auth_user_role() = 'admin')
  WITH CHECK (public.auth_user_role() = 'admin');

-- ────────────────────────────────────────────────────────────────────────────
--  TRIGGER: auto-set original_general_registration_date on INSERT
--  This is the anchor date that priority is calculated from — must be set
--  once and NEVER updated afterwards, even when parent later pays €30 to
--  join the official list.
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_set_original_date()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.general_registration_date IS NULL THEN
    NEW.general_registration_date := COALESCE(NEW.joined_at, now());
  END IF;
  IF NEW.list_type = 'official' AND NEW.official_registration_date IS NULL THEN
    NEW.official_registration_date := now();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_waitlist_set_original_date ON public.waitlist;
CREATE TRIGGER trg_waitlist_set_original_date
  BEFORE INSERT ON public.waitlist
  FOR EACH ROW
  EXECUTE FUNCTION public.waitlist_set_original_date();

-- ────────────────────────────────────────────────────────────────────────────
--  TRIGGER: when list_type flips general → official, stamp the official date
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_stamp_official_date()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.list_type = 'official'
     AND (OLD.list_type IS NULL OR OLD.list_type <> 'official')
     AND NEW.official_registration_date IS NULL THEN
    NEW.official_registration_date := now();
  END IF;
  -- Guard: never overwrite the original general date.
  IF OLD.general_registration_date IS NOT NULL THEN
    NEW.general_registration_date := OLD.general_registration_date;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_waitlist_stamp_official_date ON public.waitlist;
CREATE TRIGGER trg_waitlist_stamp_official_date
  BEFORE UPDATE ON public.waitlist
  FOR EACH ROW
  EXECUTE FUNCTION public.waitlist_stamp_official_date();

-- ────────────────────────────────────────────────────────────────────────────
--  FUNCTION: find children on general list who turn 4 today
--  Used by the daily 4th-birthday cron edge function.
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_children_turning_four_today()
RETURNS TABLE (
  waitlist_id uuid,
  child_id uuid,
  parent_id uuid,
  child_first_name text,
  parent_email text,
  parent_first_name text,
  date_of_birth date
)
LANGUAGE sql STABLE
AS $$
  SELECT
    w.id                    AS waitlist_id,
    c.id                    AS child_id,
    w.parent_id             AS parent_id,
    c.first_name            AS child_first_name,
    p.email                 AS parent_email,
    p.first_name            AS parent_first_name,
    c.date_of_birth         AS date_of_birth
  FROM public.waitlist w
  JOIN public.children c ON c.id = w.child_id
  JOIN public.profiles p ON p.id = w.parent_id
  WHERE w.list_type = 'general'
    AND w.status IN ('active', 'no_status')
    AND w.confirmation_status = 'confirmed'
    AND c.date_of_birth = (CURRENT_DATE - INTERVAL '4 years')::date;
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  FUNCTION: matching engine — given a freed slot, return prioritised
--  candidates. Uses two rules:
--    1. list_type ranking: mini_survival > official > general
--    2. Within the same list_type, oldest general_registration_date wins.
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_match_candidates(
  p_location_id uuid,
  p_day_of_week smallint,     -- 0 = Sunday, 6 = Saturday
  p_slot_time time,
  p_lesson_type text,
  p_limit int DEFAULT 10
)
RETURNS TABLE (
  waitlist_id uuid,
  parent_id uuid,
  child_id uuid,
  list_type text,
  general_registration_date timestamptz,
  official_registration_date timestamptz,
  priority_rank int
)
LANGUAGE plpgsql STABLE
AS $$
DECLARE
  v_day_name text;
BEGIN
  -- Map 0-6 to lower-case English day name matching availability_grid keys.
  v_day_name := CASE p_day_of_week
    WHEN 0 THEN 'sunday'
    WHEN 1 THEN 'monday'
    WHEN 2 THEN 'tuesday'
    WHEN 3 THEN 'wednesday'
    WHEN 4 THEN 'thursday'
    WHEN 5 THEN 'friday'
    WHEN 6 THEN 'saturday'
  END;

  RETURN QUERY
  WITH candidates AS (
    SELECT
      w.id                                AS waitlist_id,
      w.parent_id                         AS parent_id,
      w.child_id                          AS child_id,
      w.list_type                         AS list_type,
      w.general_registration_date         AS general_registration_date,
      w.official_registration_date        AS official_registration_date,
      CASE w.list_type
        WHEN 'mini_survival' THEN 1
        WHEN 'official' THEN 2
        ELSE 3
      END                                 AS list_priority
    FROM public.waitlist w
    WHERE p_location_id = ANY (w.preferred_location_ids)
      AND w.confirmation_status = 'confirmed'
      AND w.status IN ('active', 'no_status')
      AND (w.lesson_type = p_lesson_type OR w.lesson_type IS NULL OR w.lesson_type = 'no_preference')
      -- Slot falls inside one of parent's availability windows for this day.
      AND (
        w.availability_grid IS NULL   -- legacy entries with no grid → treat as available anywhere
        OR EXISTS (
          SELECT 1
          FROM jsonb_array_elements(COALESCE(w.availability_grid -> v_day_name, '[]'::jsonb)) AS window(pair)
          WHERE (window.pair ->> 0)::time <= p_slot_time
            AND (window.pair ->> 1)::time >  p_slot_time
        )
      )
  )
  SELECT
    c.waitlist_id, c.parent_id, c.child_id,
    c.list_type, c.general_registration_date, c.official_registration_date,
    ROW_NUMBER() OVER (
      ORDER BY c.list_priority ASC, c.general_registration_date ASC
    )::int AS priority_rank
  FROM candidates c
  ORDER BY c.list_priority ASC, c.general_registration_date ASC
  LIMIT p_limit;
END;
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  FUNCTION: parent's position rank inside a specific slot's queue
--  Called from the mobile app so the parent sees "you are #3 for Mon 15:00
--  at Nijkerk".
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_parent_position(
  p_parent_id uuid,
  p_location_id uuid,
  p_day_of_week smallint,
  p_slot_time time,
  p_lesson_type text DEFAULT 'no_preference'
)
RETURNS TABLE (position int, total int)
LANGUAGE plpgsql STABLE
AS $$
DECLARE
  v_day_name text;
  v_general_date timestamptz;
  v_list_type text;
BEGIN
  v_day_name := CASE p_day_of_week
    WHEN 0 THEN 'sunday'
    WHEN 1 THEN 'monday'
    WHEN 2 THEN 'tuesday'
    WHEN 3 THEN 'wednesday'
    WHEN 4 THEN 'thursday'
    WHEN 5 THEN 'friday'
    WHEN 6 THEN 'saturday'
  END;

  -- Find the parent's own general registration date for this location.
  SELECT w.general_registration_date, w.list_type
    INTO v_general_date, v_list_type
  FROM public.waitlist w
  WHERE w.parent_id = p_parent_id
    AND p_location_id = ANY (w.preferred_location_ids)
    AND w.confirmation_status = 'confirmed'
  ORDER BY w.general_registration_date ASC
  LIMIT 1;

  IF v_general_date IS NULL THEN
    RETURN QUERY SELECT 0::int, 0::int;
    RETURN;
  END IF;

  RETURN QUERY
  WITH slot_queue AS (
    SELECT
      w.id,
      w.parent_id,
      w.general_registration_date,
      CASE w.list_type
        WHEN 'mini_survival' THEN 1
        WHEN 'official' THEN 2
        ELSE 3
      END AS lp
    FROM public.waitlist w
    WHERE p_location_id = ANY (w.preferred_location_ids)
      AND w.confirmation_status = 'confirmed'
      AND w.status IN ('active', 'no_status')
      AND (w.lesson_type = p_lesson_type OR w.lesson_type IS NULL OR w.lesson_type = 'no_preference')
      AND (
        w.availability_grid IS NULL
        OR EXISTS (
          SELECT 1
          FROM jsonb_array_elements(COALESCE(w.availability_grid -> v_day_name, '[]'::jsonb)) AS window(pair)
          WHERE (window.pair ->> 0)::time <= p_slot_time
            AND (window.pair ->> 1)::time >  p_slot_time
        )
      )
  ),
  ranked AS (
    SELECT id, parent_id,
           ROW_NUMBER() OVER (ORDER BY lp ASC, general_registration_date ASC) AS rank_pos,
           COUNT(*) OVER () AS total_count
    FROM slot_queue
  )
  SELECT r.rank_pos::int AS position, r.total_count::int AS total
  FROM ranked r
  WHERE r.parent_id = p_parent_id
  LIMIT 1;
END;
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  FUNCTION: create a slot opening (called by admin / instructor UI or
--  trigger). Wraps the insert so we can atomically fire off matching later.
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_open_slot(
  p_location_id uuid,
  p_day_of_week smallint,
  p_slot_time time,
  p_lesson_type text,
  p_freed_by_child_id uuid DEFAULT NULL,
  p_freed_reason text DEFAULT 'manual_admin',
  p_notes text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
AS $$
DECLARE
  v_opening_id uuid;
BEGIN
  INSERT INTO public.waitlist_slot_openings
    (location_id, day_of_week, slot_time, lesson_type,
     freed_by_child_id, freed_reason, notes)
  VALUES
    (p_location_id, p_day_of_week, p_slot_time, p_lesson_type,
     p_freed_by_child_id, p_freed_reason, p_notes)
  RETURNING id INTO v_opening_id;

  RETURN v_opening_id;
END;
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  FUNCTION: mark all expired offers, called by the 10-minute expiry cron
-- ────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.waitlist_expire_stale_offers()
RETURNS TABLE (expired_count int, filled_slots int, released_slots int)
LANGUAGE plpgsql
AS $$
DECLARE
  v_expired int := 0;
  v_filled int := 0;
  v_released int := 0;
  v_opening record;
  v_winner_id uuid;
BEGIN
  -- 1. Mark individual offers as expired
  WITH stale AS (
    UPDATE public.waitlist_slot_offers
       SET response = 'expired', responded_at = now()
     WHERE response = 'pending'
       AND expires_at < now()
    RETURNING id
  )
  SELECT COUNT(*) INTO v_expired FROM stale;

  -- 2. For each slot opening in 'matched' status where all offers expired
  --    or none accepted, either award to next-highest accepter or release.
  FOR v_opening IN
    SELECT so.id
    FROM public.waitlist_slot_openings so
    WHERE so.status = 'matched'
      AND NOT EXISTS (
        SELECT 1 FROM public.waitlist_slot_offers o
        WHERE o.freed_by_reservation_id IS NULL   -- link by opening handled in app
          AND o.response = 'pending'
      )
  LOOP
    -- Look for a highest-priority accepter across offers for this opening.
    SELECT o.waitlist_id INTO v_winner_id
    FROM public.waitlist_slot_offers o
    WHERE o.response = 'accepted'
    ORDER BY o.priority_rank ASC
    LIMIT 1;

    IF v_winner_id IS NOT NULL THEN
      UPDATE public.waitlist_slot_openings
         SET status = 'filled', filled_by_waitlist_id = v_winner_id, matched_at = now()
       WHERE id = v_opening.id;
      UPDATE public.waitlist SET status = 'placed' WHERE id = v_winner_id;
      v_filled := v_filled + 1;
    ELSE
      UPDATE public.waitlist_slot_openings
         SET status = 'released'
       WHERE id = v_opening.id;
      v_released := v_released + 1;
    END IF;
  END LOOP;

  RETURN QUERY SELECT v_expired, v_filled, v_released;
END;
$$;

-- ────────────────────────────────────────────────────────────────────────────
--  RLS on waitlist_auto_reserved_lessons (parent can view own, admin can all)
-- ────────────────────────────────────────────────────────────────────────────
ALTER TABLE public.waitlist_auto_reserved_lessons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auto_reserved_own" ON public.waitlist_auto_reserved_lessons;
CREATE POLICY "auto_reserved_own" ON public.waitlist_auto_reserved_lessons FOR SELECT TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.waitlist w WHERE w.id = waitlist_id AND w.parent_id = auth.uid())
    OR public.auth_user_role() IN ('admin', 'instructor')
  );
DROP POLICY IF EXISTS "auto_reserved_admin_write" ON public.waitlist_auto_reserved_lessons;
CREATE POLICY "auto_reserved_admin_write" ON public.waitlist_auto_reserved_lessons FOR ALL TO authenticated
  USING (public.auth_user_role() IN ('admin', 'instructor'))
  WITH CHECK (public.auth_user_role() IN ('admin', 'instructor'));

-- ────────────────────────────────────────────────────────────────────────────
--  Seed default lesson types × locations mapping (Walter's current offering)
-- ────────────────────────────────────────────────────────────────────────────
INSERT INTO public.location_lesson_types (location_id, lesson_type, price_cents, enabled)
SELECT l.id, lt.lesson_type, lt.price_cents, true
FROM public.locations l
CROSS JOIN (VALUES
  ('one_on_one',         3800),
  ('one_in_two',         2700),
  ('one_in_three',       2000),
  ('survival_swimming',  2500)
) AS lt(lesson_type, price_cents)
ON CONFLICT (location_id, lesson_type) DO NOTHING;

-- Baarn location gets the special "one_in_six" option.
INSERT INTO public.location_lesson_types (location_id, lesson_type, price_cents, enabled)
SELECT l.id, 'baarn_one_in_six', 1500, true
FROM public.locations l
WHERE l.name ILIKE '%Baarn%'
ON CONFLICT (location_id, lesson_type) DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────────
--  DONE
-- ────────────────────────────────────────────────────────────────────────────
SELECT 'Phase 2 advanced waitlist automation applied ✓' AS status;
