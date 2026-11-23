-- شغّل هذا الملف كاملاً في Supabase > SQL Editor
-- مهم: بدّل 1234 برقم سري أقوى (يظهر 3 مرات في دوال admin_*)

create table bookings (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  movie_id int not null,
  seat text not null,
  name text not null,
  dept text not null,
  gender text not null,
  contact text not null,
  status text not null default 'pending',
  rejection_reason text default '',
  is_checked_in boolean not null default false,
  created_at timestamptz default now()
);
create unique index one_seat_active on bookings (movie_id, seat)
  where status in ('pending','approved');
alter table bookings enable row level security; -- بدون policies = الجدول مقفول

create function public_seats(p_movie int)
returns table(seat text, status text, is_checked_in boolean)
language sql security definer as $$
  select seat, status, is_checked_in from bookings
  where movie_id = p_movie and status in ('pending','approved') $$;

create function create_booking(p_movie int, p_seat text, p_name text,
  p_dept text, p_gender text, p_contact text)
returns text language plpgsql security definer as $$
declare c text;
begin
  loop
    c := 'CIN-' || (100 + floor(random()*900))::int;
    exit when not exists (select 1 from bookings where code = c);
  end loop;
  insert into bookings(code,movie_id,seat,name,dept,gender,contact)
  values (c,p_movie,p_seat,p_name,p_dept,p_gender,p_contact);
  return c;
end $$;

create function get_booking(p_code text)
returns setof bookings language sql security definer as $$
  select * from bookings where code = upper(trim(p_code)) $$;

create function admin_list(p_pin text)
returns setof bookings language plpgsql security definer as $$
begin
  if p_pin <> '1234' then raise exception 'bad pin'; end if;
  return query select * from bookings order by created_at;
end $$;

create function admin_set_status(p_pin text, p_id uuid, p_status text, p_reason text)
returns void language plpgsql security definer as $$
begin
  if p_pin <> '1234' then raise exception 'bad pin'; end if;
  update bookings set status = p_status, rejection_reason = coalesce(p_reason,'')
  where id = p_id;
end $$;

create function admin_checkin(p_pin text, p_id uuid)
returns boolean language plpgsql security definer as $$
declare n int;
begin
  if p_pin <> '1234' then raise exception 'bad pin'; end if;
  update bookings set is_checked_in = true
  where id = p_id and status = 'approved' and is_checked_in = false;
  get diagnostics n = row_count;
  return n = 1;
end $$;
