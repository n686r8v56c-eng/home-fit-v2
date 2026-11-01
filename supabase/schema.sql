-- Home Fit 2.0 standalone schema: does not modify existing Home Fit tables.
create extension if not exists pgcrypto;
create table if not exists public.hf2_exercises (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 name text not null, category text not null default '근력', tags text[] not null default '{}',
 details text not null default '', image_url text not null default '', video_url text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.hf2_sequences (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 name text not null, category text not null default '전체', items jsonb not null default '[]'::jsonb,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.hf2_plans (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 plan_date date not null, sequence_id uuid references public.hf2_sequences(id) on delete set null,
 title text not null, duration_minutes integer not null default 20,
 status text not null default 'planned' check (status in ('planned','done','partial','skipped')),
 actual_minutes integer not null default 0,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.hf2_settings (
 user_id uuid primary key references auth.users(id) on delete cascade,
 strategy jsonb not null default '{"strength":2,"cardio":3,"mobility":4,"strengthMin":40,"cardioMin":30,"mobilityMin":15}'::jsonb,
 goal text not null default '꾸준한 운동 습관', updated_at timestamptz not null default now()
);
create table if not exists public.hf2_bookmarks (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, category text not null default '전체', video_url text not null default '', note text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists hf2_exercises_user_idx on public.hf2_exercises(user_id);
create index if not exists hf2_sequences_user_idx on public.hf2_sequences(user_id);
create index if not exists hf2_plans_user_date_idx on public.hf2_plans(user_id,plan_date);
create index if not exists hf2_bookmarks_user_idx on public.hf2_bookmarks(user_id);
alter table public.hf2_exercises enable row level security;
alter table public.hf2_sequences enable row level security;
alter table public.hf2_plans enable row level security;
alter table public.hf2_settings enable row level security;
alter table public.hf2_bookmarks enable row level security;
do $$ declare t text; begin
 foreach t in array array['hf2_exercises','hf2_sequences','hf2_plans','hf2_settings','hf2_bookmarks'] loop
  execute format('drop policy if exists "hf2_owner_all" on public.%I', t);
  execute format('create policy "hf2_owner_all" on public.%I for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))', t);
 end loop;
end $$;
