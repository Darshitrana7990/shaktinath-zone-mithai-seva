-- Shaktinath Zone Mithai Seva-2026
-- Run this complete script in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'staff' check (role in ('admin','staff')),
  display_name text,
  created_at timestamptz not null default now()
);
create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  created_at timestamptz not null default now()
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  unit_price numeric(12,2) not null default 0 check (unit_price >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id),
  product_id uuid not null references public.products(id),
  kind text not null check (kind in ('Sale','Return')),
  quantity numeric(12,3) not null check (quantity > 0),
  unit_price numeric(12,2) not null check (unit_price >= 0),
  total_amount numeric(12,2) not null check (total_amount >= 0),
  paid_amount numeric(12,2) not null default 0 check (paid_amount >= 0 and paid_amount <= total_amount),
  payment_mode text not null check (payment_mode in ('Cash','Online','Mixed')),
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

create or replace function public.current_user_role() returns text
language sql stable security definer set search_path = public
as $$ select role from public.profiles where id = auth.uid() $$;

alter table public.profiles enable row level security;
alter table public.customers enable row level security;
alter table public.products enable row level security;
alter table public.sales enable row level security;

drop policy if exists "profile read self or admin" on public.profiles;
create policy "profile read self or admin" on public.profiles for select to authenticated using (id = auth.uid() or public.current_user_role() = 'admin');
drop policy if exists "admin manage profiles" on public.profiles;
create policy "admin manage profiles" on public.profiles for all to authenticated using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');

drop policy if exists "authenticated read customers" on public.customers;
create policy "authenticated read customers" on public.customers for select to authenticated using (true);
drop policy if exists "authenticated add customers" on public.customers;
create policy "authenticated add customers" on public.customers for insert to authenticated with check (true);
drop policy if exists "admin update customers" on public.customers;
create policy "admin update customers" on public.customers for update to authenticated using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');
drop policy if exists "admin delete customers" on public.customers;
create policy "admin delete customers" on public.customers for delete to authenticated using (public.current_user_role() = 'admin');

drop policy if exists "authenticated read products" on public.products;
create policy "authenticated read products" on public.products for select to authenticated using (true);
drop policy if exists "admin manage products" on public.products;
create policy "admin manage products" on public.products for all to authenticated using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');

drop policy if exists "authenticated read sales" on public.sales;
create policy "authenticated read sales" on public.sales for select to authenticated using (true);
drop policy if exists "authenticated create sales" on public.sales;
create policy "authenticated create sales" on public.sales for insert to authenticated with check (created_by = auth.uid());
drop policy if exists "admin update sales" on public.sales;
create policy "admin update sales" on public.sales for update to authenticated using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');
drop policy if exists "admin delete sales" on public.sales;
create policy "admin delete sales" on public.sales for delete to authenticated using (public.current_user_role() = 'admin');

-- After creating the first user in Supabase Authentication > Users,
-- copy that user's UUID and run the statement below, replacing USER_UUID.
-- update public.profiles set role='admin' where id='USER_UUID';
-- If the profile row does not exist, use:
-- insert into public.profiles(id, role, display_name) values ('USER_UUID','admin','Administrator');
