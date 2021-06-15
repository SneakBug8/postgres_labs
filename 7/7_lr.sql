----------------------------------------------------------------------------------------------
-------------------------------------16.1-----------------------------------------------------
----------------------------------------------------------------------------------------------
drop type book_data;

create type book_data as
(
    book_ref        char(6),
    book_date       timestamptz,
    total_amount    numeric(10, 2),
    ticket_no       char(13),
    passenger_id    varchar(20),
    passenger_name  text,
    contact_data    jsonb,
    flight_id       integer,
    fare_conditions varchar(10),
    amount          numeric(10, 2)
);

--------------------------------------------------------------------------------------------

drop function get_booking(br char);

create or replace function get_booking(br char(6)) returns setof book_data
    LANGUAGE plpgsql AS
$$
BEGIN
    return query
        select b.book_ref,
               book_date,
               total_amount,
               t.ticket_no,
               t.passenger_id,
               passenger_name,
               t.contact_data,
               flight_id,
               tf.fare_conditions,
               amount
        from bookings as b
                 join tickets t on b.book_ref = t.book_ref
                 join ticket_flights tf on t.ticket_no = tf.ticket_no
        where b.book_ref = br;
END;
$$;

--------------------------------------------------------------------------------------------

select *
from get_booking('00000F') as b;

----------------------------------------------------------------------------------------------
-------------------------------------16.2-----------------------------------------------------
----------------------------------------------------------------------------------------------
drop function get_booking_sql(br char);

create or replace function get_booking_sql(br char(6)) returns setof book_data
    LANGUAGE sql AS
$$
select b.book_ref,
       book_date,
       total_amount,
       t.ticket_no,
       t.passenger_id,
       passenger_name,
       t.contact_data,
       flight_id,
       tf.fare_conditions,
       amount
from bookings as b
         join tickets t on b.book_ref = t.book_ref
         join ticket_flights tf on t.ticket_no = tf.ticket_no
where b.book_ref = br;
$$;

--------------------------------------------------------------------------------------------

select *
from get_booking_sql('00000F') as b;


----------------------------------------------------------------------------------------------
-------------------------------------16.3-----------------------------------------------------
----------------------------------------------------------------------------------------------
drop function has_free_seats(_flight_id integer);

create or replace function has_free_seats(_flight_id integer) returns boolean
    language plpgsql as
$$
begin
    return
        (select count(*) > (select count(*) from ticket_flights where flight_id = _flight_id)
         from flights
                  join seats s on flights.aircraft_code = s.aircraft_code
         where flight_id = _flight_id);
end;
$$;


--------------------------------------------------------------------------------------------
-- insert into bookings
-- values ('00001X', '2017-07-29 03:30:00.000000', 0);

rollback;

CREATE OR replace PROCEDURE create_booking(_day timestamptz, _from text, _to text, _passenger_name text, _contact_data jsonb, _total_amount integer) language plpgsql AS $$DECLARE v RECORD;BEGIN
  for v IN
  SELECT *
  FROM   flights
  WHERE  date_trunc('day', scheduled_departure) = date_trunc('day', _day)
  AND    departure_airport = _from
  AND    arrival_airport = _to
  loop
  IF has_free_seats(v.flight_id) THEN
      declare newbookingref char(6) := newbookingref();
      newticketref char(13) := newticketref();
      newpassengerid char(20) := newpassengerid();
          begin
  INSERT INTO bookings(book_ref, book_date, total_amount) VALUES
              (
              newbookingref,
              CURRENT_TIMESTAMP,
              _total_amount
              );

  insert INTO tickets VALUES
              (
              newticketref,
              newbookingref,
              newpassengerid,
              _passenger_name,
              _contact_data
              );

  insert INTO ticket_flights VALUES
              (
              newticketref,
              v.flight_id,
              'Economy',
              _total_amount
              );
    end;
end IF;
END loop;
END;
$$;

create or replace procedure create_booking(_day timestamptz, _from text, _to text, _passenger_name text,
                                           _contact_data jsonb, _total_amount integer)
    language plpgsql as
$$
declare
    v record;
begin
    for v in select *
             from flights
             where date_trunc('day', scheduled_departure) = date_trunc('day', _day)
               and departure_airport = _from
               and arrival_airport = _to
        loop
            if has_free_seats(v.flight_id) then
                insert into bookings
                values ((select to_char((substring(max(book_ref) from 1 for 5))::bigint + 1, 'FM00000') || 'X'
                         from bookings
                         where book_ref like '%X'),
                        current_timestamp,
                        _total_amount);
                insert into tickets
                values ((select to_char(max(ticket_no::bigint + 1), 'FM0000000000000') from tickets),
                        (select max(book_ref) from bookings where book_ref like '%X'),
                        (select to_char((replace(max(passenger_id), ' ', '')::bigint) + 1, 'FM0000 000000')
                         from tickets),
                        _passenger_name,
                        _contact_data);
                insert into ticket_flights
                values ((select max(ticket_no) from tickets),
                        v.flight_id,
                        'Economy',
                        _total_amount);
            end if;
        end loop;

end;
$$;

--------------------------------------------------------------------------------------------
begin;
call create_booking('2017-09-10 06:50:00.000000'::timestamptz,
                    'DME',
                    'BTK',
                    'NAME LASTNAME',
                    '{}'::jsonb,
                    10000);

select b.*, f.departure_airport, f.arrival_airport
from get_booking_sql((select max(book_ref) from bookings where book_ref like '%X')) as b
         join flights as f on f.flight_id = b.flight_id;

rollback;
----------------------------------------------------------------------------------------------
-------------------------------------16.4-----------------------------------------------------
----------------------------------------------------------------------------------------------

rollback;

create or replace procedure add_passenger(_book_ref char(6), _passenger_name text, _contact_data jsonb)
    language plpgsql as
$$
declare
    v             record;
    _passenger_id varchar(20) := (select to_char((replace(max(passenger_id), ' ', '')::bigint) + 1, 'FM0000 000000')
                                  from tickets);
begin
    for v in
        select *
        from tickets
                 join ticket_flights tf on tickets.ticket_no = tf.ticket_no
        where book_ref = _book_ref
        loop
            if not has_free_seats(v.flight_id) then
                rollback;
                return;
            end if;
            insert into tickets
            values ((select to_char(max(ticket_no::bigint + 1), 'FM0000000000000') from tickets),
                    _book_ref,
                    _passenger_id,
                    _passenger_name,
                    _contact_data);
            insert into ticket_flights
            values ((select max(ticket_no) from tickets),
                    v.flight_id,
                    v.fare_conditions,
                    v.amount);
        end loop;
end;
$$;



begin;
call add_passenger('7DC7C4', 'NAME LASTNAME', '{}');

select *
from get_booking_sql('7DC7C4');


----------------------------------------------------------------------------------------------
-------------------------------------16.5-----------------------------------------------------
----------------------------------------------------------------------------------------------

create or replace function ex_test(i integer) returns integer
    language plpgsql as
$$
declare
    x integer := 1;
begin
    insert into bookings values ('FFFFFF', '2017-07-29 03:30:00.000000'::timestamptz, 1);
    x := x / i;
    return x;
exception
    when division_by_zero then
        insert into bookings values ('GGGGGG', '2017-07-29 03:30:00.000000'::timestamptz, 2);
        return x;
end;
$$;

begin;
select ex_test(1);
select * from bookings where book_ref = 'FFFFFF' or book_ref = 'GGGGGG';
rollback;
----------------------------------------------------------------------------------------------
-------------------------------------16.6-----------------------------------------------------
----------------------------------------------------------------------------------------------

create function never() returns boolean
    language sql
    immutable as
$$
select false;
$$;

select never();