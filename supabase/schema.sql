-- ====================================================================
-- Zwemschool Snorkeltje — Full Database Schema (Supabase/Postgres)
-- ====================================================================
-- Run this in Supabase SQL Editor to create all tables, policies, and
-- seed data. Safe to run multiple times (uses IF NOT EXISTS).
-- ====================================================================

-- ========== EXTENSIONS ==========
create extension if not exists "uuid-ossp";

-- ========== ENUM TYPES ==========
do $$ begin
  create type user_role as enum ('parent', 'instructor', 'admin');
exception when duplicate_object then null; end $$;

do $$ begin
  create type lesson_type as enum ('1-op-1', '1-op-2', '1-op-3', 'survival', 'vakantie');
exception when duplicate_object then null; end $$;

do $$ begin
  create type reservation_status as enum ('pending_payment', 'confirmed', 'completed', 'cancelled', 'no_show');
exception when duplicate_object then null; end $$;

do $$ begin
  create type payment_status as enum ('pending', 'paid', 'failed', 'refunded');
exception when duplicate_object then null; end $$;

do $$ begin
  create type payment_method as enum ('ideal', 'creditcard', 'credit_voucher');
exception when duplicate_object then null; end $$;

do $$ begin
  create type availability_status as enum ('pending', 'approved', 'rejected');
exception when duplicate_object then null; end $$;

do $$ begin
  create type notification_audience as enum ('parent', 'instructor', 'admin', 'all');
exception when duplicate_object then null; end $$;

-- ========== PROFILES ==========
-- Linked 1:1 with auth.users (Supabase-managed)
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role user_role not null default 'parent',
  first_name text not null,
  last_name text not null,
  email text not null,
  phone text,
  avatar_url text,
  city text,
  language text default 'NL',
  notifications_enabled boolean default true,
  fcm_token text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists idx_profiles_role on profiles(role);

-- ========== LOCATIONS ==========
create table if not exists locations (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  address text,
  city text,
  postcode text,
  active boolean default true,
  created_at timestamptz default now()
);

-- ========== CHILDREN ==========
create table if not exists children (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  first_name text not null,
  last_name text not null,
  date_of_birth date not null,
  level text default 'Beginner',
  progress int default 0 check (progress between 0 and 100),
  medical_notes text default '',
  allergies text[] default '{}',
  emergency_contact text default '',
  notes text default '',
  avatar_color text default '#0365C4',
  active boolean default true,
  created_at timestamptz default now()
);
create index if not exists idx_children_parent on children(parent_id);

-- ========== INSTRUCTOR AVAILABILITY (fixed weekly schedule) ==========
create table if not exists instructor_schedule (
  id uuid primary key default uuid_generate_v4(),
  instructor_id uuid not null references profiles(id) on delete cascade,
  day_of_week int not null check (day_of_week between 1 and 7),
  location_id uuid references locations(id),
  start_time time not null,
  end_time time not null,
  created_at timestamptz default now()
);
create index if not exists idx_ischedule_instructor on instructor_schedule(instructor_id);

-- ========== LESSONS (available bookable slots) ==========
create table if not exists lessons (
  id uuid primary key default uuid_generate_v4(),
  instructor_id uuid not null references profiles(id),
  location_id uuid not null references locations(id),
  date date not null,
  start_time time not null,
  end_time time not null,
  type lesson_type not null,
  max_students int default 1,
  price_cents int not null,
  created_at timestamptz default now()
);
create index if not exists idx_lessons_date on lessons(date);
create index if not exists idx_lessons_instructor on lessons(instructor_id);

-- ========== RESERVATIONS ==========
create table if not exists reservations (
  id uuid primary key default uuid_generate_v4(),
  lesson_id uuid not null references lessons(id),
  child_id uuid not null references children(id),
  parent_id uuid not null references profiles(id),
  status reservation_status not null default 'pending_payment',
  payment_method payment_method,
  payment_status payment_status not null default 'pending',
  amount_cents int not null,
  stripe_payment_intent_id text,
  expires_at timestamptz, -- 10-min countdown per Walter
  created_at timestamptz default now(),
  confirmed_at timestamptz,
  cancelled_at timestamptz,
  cancel_reason text
);
create index if not exists idx_reservations_parent on reservations(parent_id);
create index if not exists idx_reservations_child on reservations(child_id);
create index if not exists idx_reservations_status on reservations(status);

-- ========== CREDIT VOUCHERS (Walter's new system) ==========
create table if not exists credit_vouchers (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  initial_amount_cents int not null, -- purchase amount
  bonus_cents int default 0, -- tiered discount bonus
  current_balance_cents int not null,
  stripe_payment_intent_id text,
  created_at timestamptz default now()
);
create index if not exists idx_vouchers_parent on credit_vouchers(parent_id);

-- Voucher transactions (audit)
create table if not exists voucher_transactions (
  id uuid primary key default uuid_generate_v4(),
  voucher_id uuid not null references credit_vouchers(id) on delete cascade,
  reservation_id uuid references reservations(id),
  amount_cents int not null, -- negative = debit, positive = credit (refund)
  description text,
  created_at timestamptz default now()
);

-- ========== SKILLS / STEP-BY-STEP PLAN ==========
create table if not exists skills (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  level text not null, -- Beginner / Gevorderd Beginner / Gevorderd / Diploma A / B / C
  description text,
  sort_order int default 0
);

create table if not exists skill_steps (
  id uuid primary key default uuid_generate_v4(),
  skill_id uuid not null references skills(id) on delete cascade,
  step_order int not null,
  description text not null
);

create table if not exists child_skills (
  id uuid primary key default uuid_generate_v4(),
  child_id uuid not null references children(id) on delete cascade,
  skill_id uuid not null references skills(id) on delete cascade,
  progress_pct int default 0,
  steps_completed int default 0,
  unique(child_id, skill_id)
);

-- ========== PROGRESS UPDATES (Walter: 2 text fields, notify toggle) ==========
create table if not exists progress_updates (
  id uuid primary key default uuid_generate_v4(),
  child_id uuid not null references children(id) on delete cascade,
  instructor_id uuid not null references profiles(id),
  lesson_id uuid references lessons(id),
  new_level text,
  new_progress int,
  mood int check (mood between 0 and 4),
  parent_notes text, -- visible to parent
  colleague_notes text, -- private to instructors
  notified_parent boolean default false,
  is_improvement boolean default false, -- only notify parent when true
  created_at timestamptz default now()
);
create index if not exists idx_progress_child on progress_updates(child_id);

-- ========== CONVERSATIONS & MESSAGES ==========
-- Multi-party: parent + regular instructor + admin all can participate
create table if not exists conversations (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  instructor_id uuid references profiles(id),
  child_id uuid references children(id),
  subject text,
  last_message text,
  last_message_at timestamptz,
  created_at timestamptz default now()
);
create index if not exists idx_convs_parent on conversations(parent_id);
create index if not exists idx_convs_instructor on conversations(instructor_id);

create table if not exists messages (
  id uuid primary key default uuid_generate_v4(),
  conversation_id uuid not null references conversations(id) on delete cascade,
  sender_id uuid not null references profiles(id),
  body text not null,
  attachment_url text,
  read_by uuid[] default '{}', -- array of user IDs who have read it
  created_at timestamptz default now()
);
create index if not exists idx_messages_conv on messages(conversation_id);

-- ========== INSTRUCTOR VACATION REQUESTS (Walter) ==========
create table if not exists vacation_requests (
  id uuid primary key default uuid_generate_v4(),
  instructor_id uuid not null references profiles(id) on delete cascade,
  start_date date not null,
  end_date date not null,
  reason text,
  notes text,
  status availability_status default 'pending',
  reviewed_by uuid references profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz default now()
);
create index if not exists idx_vacreq_instructor on vacation_requests(instructor_id);

-- ========== WAITLIST (fully automated per Walter) ==========
create table if not exists waitlist (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  child_id uuid not null references children(id) on delete cascade,
  preferred_location_ids uuid[] not null default '{}',
  preferred_days int[] not null default '{}', -- 1-7
  preferred_time_start time,
  preferred_time_end time,
  registration_fee_paid boolean default false,
  position int,
  joined_at timestamptz default now()
);
create index if not exists idx_waitlist_parent on waitlist(parent_id);

-- Slot offers sent to matching waitlist members (24-hour claim window)
create table if not exists waitlist_offers (
  id uuid primary key default uuid_generate_v4(),
  waitlist_id uuid not null references waitlist(id) on delete cascade,
  lesson_id uuid not null references lessons(id),
  offered_at timestamptz default now(),
  expires_at timestamptz not null, -- +24 hours
  claimed_at timestamptz,
  declined_at timestamptz
);

-- ========== REVIEWS (Walter: <6 need owner response before publish) ==========
create table if not exists reviews (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  instructor_id uuid references profiles(id),
  location_id uuid references locations(id),
  rating int not null check (rating between 1 and 10),
  text text not null,
  helpful_count int default 0,
  owner_response text,
  published boolean default false,
  created_at timestamptz default now(),
  responded_at timestamptz
);
create index if not exists idx_reviews_instructor on reviews(instructor_id);

-- Auto-publish reviews >=6 or when owner responds
create or replace function auto_publish_review() returns trigger as $$
begin
  if new.rating >= 6 then
    new.published := true;
  elsif new.owner_response is not null and old.owner_response is null then
    new.published := true;
    new.responded_at := now();
  end if;
  return new;
end; $$ language plpgsql;

drop trigger if exists trg_auto_publish_review on reviews;
create trigger trg_auto_publish_review
  before insert or update on reviews
  for each row execute function auto_publish_review();

-- ========== NOTIFICATIONS ==========
create table if not exists notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  audience notification_audience not null,
  type text not null, -- lesson_reminder, progress_update, vacation_approved, etc.
  title text not null,
  body text not null,
  payload jsonb default '{}',
  read boolean default false,
  created_at timestamptz default now()
);
create index if not exists idx_notif_user on notifications(user_id) where read = false;

-- ========== REGISTRATION FEE (€30 at signup, €15 refund if no-start) ==========
create table if not exists registration_payments (
  id uuid primary key default uuid_generate_v4(),
  parent_id uuid not null references profiles(id) on delete cascade,
  amount_paid_cents int not null default 3000,
  amount_consumed_cents int default 0, -- €15 when officially start, another €15 for service
  refunded_cents int default 0,
  stripe_payment_intent_id text,
  paid_at timestamptz default now()
);

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================================================

alter table profiles enable row level security;
alter table children enable row level security;
alter table reservations enable row level security;
alter table credit_vouchers enable row level security;
alter table voucher_transactions enable row level security;
alter table progress_updates enable row level security;
alter table conversations enable row level security;
alter table messages enable row level security;
alter table vacation_requests enable row level security;
alter table waitlist enable row level security;
alter table waitlist_offers enable row level security;
alter table reviews enable row level security;
alter table notifications enable row level security;
alter table registration_payments enable row level security;

-- Profiles: users see own + instructors/admins see all
drop policy if exists "profiles_self_read" on profiles;
create policy "profiles_self_read" on profiles for select
  using (auth.uid() = id or exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('instructor', 'admin')));

drop policy if exists "profiles_self_update" on profiles;
create policy "profiles_self_update" on profiles for update using (auth.uid() = id);

-- Children: parent sees own; instructors see all (need medical access)
drop policy if exists "children_parent_read" on children;
create policy "children_parent_read" on children for select
  using (parent_id = auth.uid() or exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('instructor', 'admin')));

drop policy if exists "children_parent_write" on children;
create policy "children_parent_write" on children for all
  using (parent_id = auth.uid());

-- Reservations: parent sees own, instructor sees lessons they teach, admin sees all
drop policy if exists "reservations_read" on reservations;
create policy "reservations_read" on reservations for select using (
  parent_id = auth.uid()
  or exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
  or exists (select 1 from lessons l where l.id = reservations.lesson_id and l.instructor_id = auth.uid())
);

drop policy if exists "reservations_parent_write" on reservations;
create policy "reservations_parent_write" on reservations for all using (parent_id = auth.uid());

-- Credit vouchers: parent only
drop policy if exists "vouchers_own" on credit_vouchers;
create policy "vouchers_own" on credit_vouchers for all using (parent_id = auth.uid());

drop policy if exists "voucher_trans_own" on voucher_transactions;
create policy "voucher_trans_own" on voucher_transactions for all using (
  exists (select 1 from credit_vouchers v where v.id = voucher_transactions.voucher_id and v.parent_id = auth.uid())
);

-- Progress updates: parent sees for own child (parent_notes only), instructor sees full
drop policy if exists "progress_parent_read" on progress_updates;
create policy "progress_parent_read" on progress_updates for select using (
  exists (select 1 from children c where c.id = progress_updates.child_id and c.parent_id = auth.uid())
  or exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('instructor', 'admin'))
);

drop policy if exists "progress_instructor_write" on progress_updates;
create policy "progress_instructor_write" on progress_updates for insert with check (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('instructor', 'admin'))
);

-- Conversations: participants only
drop policy if exists "convs_participant" on conversations;
create policy "convs_participant" on conversations for all using (
  parent_id = auth.uid()
  or instructor_id = auth.uid()
  or exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);

drop policy if exists "messages_participant" on messages;
create policy "messages_participant" on messages for all using (
  exists (
    select 1 from conversations c
    where c.id = messages.conversation_id
    and (c.parent_id = auth.uid() or c.instructor_id = auth.uid()
         or exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin'))
  )
);

-- Vacation requests: instructor sees own, admin sees all
drop policy if exists "vacreq_own" on vacation_requests;
create policy "vacreq_own" on vacation_requests for all using (
  instructor_id = auth.uid()
  or exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);

-- Waitlist: parent sees own, admin all
drop policy if exists "waitlist_own" on waitlist;
create policy "waitlist_own" on waitlist for all using (
  parent_id = auth.uid()
  or exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);

-- Reviews: published visible to all, owner can respond
drop policy if exists "reviews_public_read" on reviews;
create policy "reviews_public_read" on reviews for select using (published = true or parent_id = auth.uid());

drop policy if exists "reviews_write" on reviews;
create policy "reviews_write" on reviews for insert with check (parent_id = auth.uid());

drop policy if exists "reviews_admin_respond" on reviews;
create policy "reviews_admin_respond" on reviews for update using (
  exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);

-- Notifications: own only
drop policy if exists "notifs_own" on notifications;
create policy "notifs_own" on notifications for all using (user_id = auth.uid());

-- Registration payments: own only
drop policy if exists "regpay_own" on registration_payments;
create policy "regpay_own" on registration_payments for all using (parent_id = auth.uid());

-- ====================================================================
-- SEED DATA (starter content for Walter's Snorkeltje)
-- ====================================================================

insert into locations (name, address, city) values
  ('De Bilt', 'Sportpark De Bilt', 'De Bilt'),
  ('Bad Hulckesteijn', 'Zwembad Hulckesteijn', 'Nijkerk'),
  ('Garderen', 'Zwembad Garderen', 'Garderen'),
  ('Ampt van Nijkerk', 'Zwembad Ampt', 'Nijkerk'),
  ('Wolfheze', 'Zwembad Wolfheze', 'Wolfheze'),
  ('Dordrecht', 'Sportboulevard Dordrecht', 'Dordrecht'),
  ('Soestduinen', 'Zwembad Soest', 'Soest')
on conflict do nothing;

insert into skills (name, level, sort_order) values
  ('Drijven', 'Beginner', 1),
  ('Ademhaling', 'Beginner', 2),
  ('Vrije slag armen', 'Gevorderd Beginner', 3),
  ('Rugslag basis', 'Gevorderd Beginner', 4),
  ('Keerbocht', 'Gevorderd', 5),
  ('Schoolslag', 'Gevorderd', 6),
  ('Duiken', 'Diploma A', 7),
  ('Survival zwemmen', 'Diploma B', 8)
on conflict do nothing;
