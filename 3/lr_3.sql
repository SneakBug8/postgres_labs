-- лр 3


-- 1
select b.book_ref, t.passenger_name, f.scheduled_departure
from bookings as b
         join tickets t on b.book_ref = t.book_ref
         join ticket_flights tf on t.ticket_no = tf.ticket_no
         join flights f on f.flight_id = tf.flight_id
where t.passenger_name = 'VALERIY TIKHONOV'
  and f.scheduled_departure > '2017-09-02'
  and f.scheduled_departure < '2017-09-03';

create index ind_t_name on tickets using btree (passenger_name);

create index ind_f_scheduled_dep on flights using btree (scheduled_departure);


-- 2
select a_dep.airport_name, a_arr.airport_name, f.scheduled_departure, f.scheduled_arrival
from flights as f
         left join airports as a_arr on f.arrival_airport = a_arr.airport_code
         left join airports as a_dep on f.departure_airport = a_dep.airport_code
where a_arr.airport_name = 'Воронеж'
  and a_dep.airport_name = 'Домодедово'
  and f.scheduled_departure > '2017-01-01'
  and f.scheduled_arrival < '2020-01-03';

create index ind_a_code_name on airports_data using btree (airport_code, airport_name);

create index ind_f_dep_arr on flights using btree (scheduled_departure, scheduled_arrival);


-- 3
explain
select b.book_ref, t.passenger_name, f.scheduled_departure
from bookings as b
         join tickets t on b.book_ref = t.book_ref
         join ticket_flights tf on t.ticket_no = tf.ticket_no
         join flights f on f.flight_id = tf.flight_id
where t.passenger_name = 'VALERIY TIKHONOV'
  and f.scheduled_departure > '2017-09-02'
  and f.scheduled_departure < '2017-09-03';

set enable_indexscan to off;
set enable_indexonlyscan to off;
set enable_bitmapscan to off;

set enable_indexscan to on;
set enable_indexonlyscan to on;
set enable_bitmapscan to on;

explain
select a_dep.airport_name, a_arr.airport_name, f.scheduled_departure, f.scheduled_arrival
from flights as f
         left join airports as a_arr on f.arrival_airport = a_arr.airport_code
         left join airports as a_dep on f.departure_airport = a_dep.airport_code
where a_arr.airport_name = 'Воронеж'
  and a_dep.airport_name = 'Домодедово'
  and f.scheduled_departure > '2017-01-01'
  and f.scheduled_arrival < '2020-01-03';

-- set enable_seqscan to on;

-- 4
SELECT relname, indexrelname, idx_scan
FROM pg_catalog.pg_stat_user_indexes
WHERE schemaname = 'bookings';

-- 5, 6
set join_collapse_limit to 1;

explain (analyze)
select *
from bookings as b
         join tickets t on b.book_ref = t.book_ref
         join ticket_flights tf on t.ticket_no = tf.ticket_no
         join flights f on f.flight_id = tf.flight_id
         join airports_data ad on ad.airport_code = f.arrival_airport
         join tickets t2 on b.book_ref = t2.book_ref;

explain (analyze)
select *
from flights as f
         join ticket_flights tf on f.flight_id = tf.flight_id
         join tickets t on t.ticket_no = tf.ticket_no
         join bookings b on b.book_ref = t.book_ref
         join tickets t2 on b.book_ref = t2.book_ref
         join airports_data ad on ad.airport_code = f.arrival_airport;



set enable_bitmapscan to on;
set enable_hashagg to on;
set enable_hashjoin to on;
set enable_indexscan to on;
set enable_indexonlyscan to on;
set enable_material to on;
set enable_mergejoin to on;
set enable_nestloop to on;
set enable_seqscan to on;
set enable_sort to on;
set enable_tidscan to on;

