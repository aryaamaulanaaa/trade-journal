-- Jalankan di Supabase → SQL Editor → Run (sekali saja).
-- Tabel ini menyimpan jurnal; satu baris per trade.

create table if not exists public.journal (
  id          text primary key,
  updated_at  bigint not null default 0,
  deleted     boolean not null default false,
  payload     jsonb not null
);

-- Akses dari app (anon key). Baca peringatan di bawah.
alter table public.journal enable row level security;

drop policy if exists "journal anon all" on public.journal;
create policy "journal anon all" on public.journal
  for all
  to anon
  using (true)
  with check (true);

-- PERINGATAN
-- Siapa pun yang memiliki Project URL + anon key dapat membaca/menulis tabel ini.
-- Jangan simpan informasi sensitif. Untuk pemakaian pribadi, ini setara
-- "URL rahasia" — jangan publikasikan URL project-mu.
