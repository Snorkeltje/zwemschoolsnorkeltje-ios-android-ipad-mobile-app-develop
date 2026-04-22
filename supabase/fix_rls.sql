-- Enable RLS on all 6 tables flagged as UNRESTRICTED in dashboard.
-- Policies give parents/instructors READ access; writes are service-role only
-- (admin, backend triggers, Edge Functions).

-- ============ LOCATIONS ============
ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "locations_read_all" ON public.locations;
CREATE POLICY "locations_read_all" ON public.locations
  FOR SELECT TO authenticated USING (true);

-- ============ LESSONS ============
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "lessons_read_involved" ON public.lessons;
CREATE POLICY "lessons_read_involved" ON public.lessons
  FOR SELECT TO authenticated
  USING (
    -- Instructor can read their own lessons
    instructor_id = auth.uid()
    -- Parent can read lessons where any of their children are reserved
    OR EXISTS (
      SELECT 1 FROM public.reservations r
      JOIN public.children c ON c.id = r.child_id
      WHERE r.lesson_id = lessons.id AND c.parent_id = auth.uid()
    )
  );

-- ============ SKILLS (curriculum — readable by everyone authenticated) ============
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "skills_read_all" ON public.skills;
CREATE POLICY "skills_read_all" ON public.skills
  FOR SELECT TO authenticated USING (true);

-- ============ SKILL_STEPS (curriculum — readable by everyone authenticated) ============
ALTER TABLE public.skill_steps ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "skill_steps_read_all" ON public.skill_steps;
CREATE POLICY "skill_steps_read_all" ON public.skill_steps
  FOR SELECT TO authenticated USING (true);

-- ============ CHILD_SKILLS ============
ALTER TABLE public.child_skills ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "child_skills_read_own" ON public.child_skills;
CREATE POLICY "child_skills_read_own" ON public.child_skills
  FOR SELECT TO authenticated
  USING (
    -- Parent: own child
    EXISTS (SELECT 1 FROM public.children c WHERE c.id = child_skills.child_id AND c.parent_id = auth.uid())
    -- Instructor/admin: all
    OR public.auth_user_role() IN ('instructor', 'admin')
  );
DROP POLICY IF EXISTS "child_skills_write_instructor" ON public.child_skills;
CREATE POLICY "child_skills_write_instructor" ON public.child_skills
  FOR ALL TO authenticated
  USING (public.auth_user_role() IN ('instructor', 'admin'))
  WITH CHECK (public.auth_user_role() IN ('instructor', 'admin'));

-- ============ INSTRUCTOR_SCHEDULE ============
ALTER TABLE public.instructor_schedule ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "instructor_schedule_read_self" ON public.instructor_schedule;
CREATE POLICY "instructor_schedule_read_self" ON public.instructor_schedule
  FOR SELECT TO authenticated
  USING (
    instructor_id = auth.uid()
    OR public.auth_user_role() = 'admin'
  );
DROP POLICY IF EXISTS "instructor_schedule_write_self" ON public.instructor_schedule;
CREATE POLICY "instructor_schedule_write_self" ON public.instructor_schedule
  FOR ALL TO authenticated
  USING (instructor_id = auth.uid() OR public.auth_user_role() = 'admin')
  WITH CHECK (instructor_id = auth.uid() OR public.auth_user_role() = 'admin');

-- Verify
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename IN
  ('locations', 'lessons', 'skills', 'skill_steps', 'child_skills', 'instructor_schedule')
ORDER BY tablename;
