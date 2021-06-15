create extension pg_stat_statements;

SELECT query, total_exec_time, calls FROM pg_stat_statements ORDER BY calls DESC;

SELECT 5000 / (sum(total_exec_time) / 1000) as tps
FROM pg_stat_statements
where calls = 5000;

-------------------------------------------------------------------

drop index ind_1;
create index ind_1 on ticket_flights (amount) where fare_conditions = 'Economy';

select tickets.passenger_name
from tickets
         full join ticket_flights
                   on ticket_flights.ticket_no = tickets.ticket_no
where ticket_flights.amount > 70000
  and fare_conditions = 'Economy';



drop index ind_2;
create index ind_2 on flights (status) where status = 'Scheduled';

select tickets.passenger_name,
       flights.departure_airport,
       flights.arrival_airport,
       flights.scheduled_departure,
       flights.scheduled_arrival,
       boarding_passes.seat_no
from tickets
         join ticket_flights on tickets.ticket_no = ticket_flights.ticket_no
         join flights on ticket_flights.flight_id = flights.flight_id
         join boarding_passes on tickets.ticket_no = boarding_passes.ticket_no
where flights.status = 'Scheduled';



drop index ind_3;
create index ind_3 on flights (flight_id) where actual_arrival is not null;


select arr_pass + dep_pass as productivity, airport_name
from (
         select avg(sub2.cnt_pass) as arr_pass, arrival_airport
         from (
                  select count(*) as cnt_pass, arrival_airport, date_trunc('day', actual_arrival) as day
                  from ticket_flights
                           join flights on flights.flight_id = ticket_flights.flight_id
                  where actual_arrival is not null
                  group by arrival_airport, day
                  order by arrival_airport
              ) as sub2
         group by arrival_airport
     ) as arr
         join (
    select avg(sub1.cnt_pass) as dep_pass, departure_airport
    from (
             select count(*) as cnt_pass, departure_airport, date_trunc('day', actual_departure) as day
             from ticket_flights
                      join flights on flights.flight_id = ticket_flights.flight_id
             where actual_departure is not null
             group by departure_airport, day
             order by departure_airport
         ) as sub1
    group by departure_airport
) as dep on arr.arrival_airport = dep.departure_airport
         join airports on airports.airport_code = arr.arrival_airport
order by productivity desc
limit 10;

-------------------------------------------------------
SELECT *
FROM tickets t
WHERE to_tsvector(t.passenger_name) @@
      to_tsquery('PAVEL & IVANOV')
  AND bookings.now() - interval '10 days' < (
    SELECT b.book_date
    FROM bookings b
    WHERE upper(b.book_ref) = upper(t.book_ref)
);

SELECT *
FROM tickets t
join bookings b on b.book_ref = t.book_ref
WHERE t.passenger_name = 'PAVEL IVANOV'
  AND bookings.now() - interval '10 days' < b.book_date;
