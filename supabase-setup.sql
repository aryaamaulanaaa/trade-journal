-- Setup Supabase: jurnal pribadi dengan login + RLS.
-- Jalankan sekali di Supabase -> SQL Editor -> Run.
--
-- PENTING: kalau kamu pernah menjalankan versi SQL lama (tanpa user_id),
-- hapus dulu tabelnya dengan menghapus tanda komentar di baris berikut.
-- Ini menghapus semua data di tabel journal.
-- drop table if exists public.journal;

create table if not exists public.journal (
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id          text not null,
  updated_at  bigint not null default 0,
  deleted     boolean not null default false,
  payload     jsonb not null,
  primary key (user_id, id)
);

alter table public.journal enable row level security;

-- buang policy lama yang terbuka (kalau ada)
drop policy if exists "journal anon all" on public.journal;
drop policy if exists "journal own rows" on public.journal;

-- hanya pemilik baris yang bisa baca/tulis
create policy "journal own rows" on public.journal
  for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

revoke all on public.journal from anon;
grant select, insert, update, delete on public.journal to authenticated;
