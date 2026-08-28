-- =============================================================
-- ROBOTIK HUB — Supabase Setup Script
-- =============================================================
-- File ini TIDAK perlu diupload ke Cloudflare / GitHub.
-- Cara pakai:
-- 1. Buka project Supabase kamu -> menu "SQL Editor"
-- 2. Klik "New query", tempel SELURUH isi file ini
-- 3. Klik "Run"
-- =============================================================

create extension if not exists "pgcrypto";

create table if not exists projects (
  id uuid primary key default gen_random_uuid(),
  name text,
  title text not null,
  category text not null check (category in ('arduino', 'robotik')),
  description text not null,
  code text,
  video_url text,
  link_url text,
  file_path text,
  file_original_name text,
  image_path text,
  created_at timestamptz not null default now()
);

create index if not exists idx_projects_category on projects (category);
create index if not exists idx_projects_created_at on projects (created_at desc);

alter table projects enable row level security;

drop policy if exists "Public read access" on projects;
create policy "Public read access"
  on projects for select
  using (true);

drop policy if exists "Public insert access" on projects;
create policy "Public insert access"
  on projects for insert
  with check (true);

-- Buat bucket storage manual lewat dashboard:
--   Menu "Storage" -> "New bucket" -> nama: project-files -> Public: ON
-- Lalu jalankan policy berikut:

drop policy if exists "Public read files" on storage.objects;
create policy "Public read files"
  on storage.objects for select
  using (bucket_id = 'project-files');

drop policy if exists "Public upload files" on storage.objects;
create policy "Public upload files"
  on storage.objects for insert
  with check (bucket_id = 'project-files');
