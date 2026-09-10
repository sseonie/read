create table if not exists public.journal_states (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.journal_states enable row level security;

drop policy if exists "Users can read their own journal" on public.journal_states;
create policy "Users can read their own journal"
on public.journal_states for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can create their own journal" on public.journal_states;
create policy "Users can create their own journal"
on public.journal_states for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own journal" on public.journal_states;
create policy "Users can update their own journal"
on public.journal_states for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
