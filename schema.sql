
-- LensFlow UAT + SUS: run in the Supabase SQL Editor.
-- Prefer a separate Supabase project for anonymous research submissions.
-- The public browser can INSERT only. Never put service_role keys in HTML.

create table if not exists public.uat_submissions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  participant_id text not null unique check (length(trim(participant_id)) between 1 and 60),
  device_browser text check (device_browser is null or length(device_browser) <= 150),
  task_results jsonb not null check (
    jsonb_typeof(task_results) = 'array' and jsonb_array_length(task_results) = 12
  ),
  uat_feedback jsonb not null default '{}'::jsonb check (jsonb_typeof(uat_feedback) = 'object'),
  sus_answers integer[] not null check (
    array_length(sus_answers,1) = 10 and
    sus_answers[1] between 1 and 5 and sus_answers[2] between 1 and 5 and
    sus_answers[3] between 1 and 5 and sus_answers[4] between 1 and 5 and
    sus_answers[5] between 1 and 5 and sus_answers[6] between 1 and 5 and
    sus_answers[7] between 1 and 5 and sus_answers[8] between 1 and 5 and
    sus_answers[9] between 1 and 5 and sus_answers[10] between 1 and 5
  ),
  sus_feedback jsonb not null default '{}'::jsonb check (jsonb_typeof(sus_feedback) = 'object'),
  sus_score numeric(5,1) generated always as (
    (
      (sus_answers[1]-1) + (5-sus_answers[2]) +
      (sus_answers[3]-1) + (5-sus_answers[4]) +
      (sus_answers[5]-1) + (5-sus_answers[6]) +
      (sus_answers[7]-1) + (5-sus_answers[8]) +
      (sus_answers[9]-1) + (5-sus_answers[10])
    ) * 2.5
  ) stored
);

alter table public.uat_submissions enable row level security;

-- Remove default access, then allow ONLY anonymous submission.
revoke all on table public.uat_submissions from anon, authenticated;
grant insert on table public.uat_submissions to anon;

-- RLS: anonymous users may submit, but cannot read, update or delete responses.
-- A generated score is calculated in the database, not trusted from the browser.
drop policy if exists "Allow anonymous UAT submissions" on public.uat_submissions;
create policy "Allow anonymous UAT submissions"
on public.uat_submissions for insert to anon
with check (true);

-- IMPORTANT: No SELECT policy is created. Review responses privately
-- in Supabase Dashboard / SQL Editor (privileged database connection).

-- Optional private reporting query (run in SQL Editor):
-- select participant_id, created_at, sus_score, task_results,
--        uat_feedback, sus_feedback
-- from public.uat_submissions
-- order by created_at desc;

-- Optional SUS summary (run in SQL Editor):
-- select count(*) as participants,
--        round(avg(sus_score), 1) as average_sus_score,
--        min(sus_score) as lowest_score,
--        max(sus_score) as highest_score
-- from public.uat_submissions;
