create table t (
    point point not null ,
    time timestamp not null
);

do
$$
    declare
        i int;
    begin
        for i in 1..1000 loop
            with a as (select * from floor(random() * 100)),
     b as (select * from floor(random() * 100))
insert into t
values (point((SELECT * from a), (SELECT * from b)),
       make_timestamp(2020, 11, floor(1 + random() * 29)::int, 1, 1, 1) );

            end loop;
    end;
$$

create index on t using gist (point);

create extension btree_gist;

create index on t using gist (point, time);


insert into t(point, time) VALUES
        ('(0.007,0.003)', '2020-11-11 10:10:10.000000'),
        ('(0.004,0.002)', '2020-11-11 10:10:10.000000'),
        ('(0.005,0.005)', '2020-11-11 10:10:10.000000'),
        ('(0.005,0.008)', '2020-11-11 10:10:10.000000'),
        ('(0.009,0.001)', '2020-11-11 10:10:10.000000');

select *, (point <-> '(0.0, 0.0)') as dist
from t
where
      time > '2020-11-11 00:00:00'
  and time < '2020-11-12 00:00:00'
  and (point <-> '(0.0, 0.0)') < 2;


drop index t_point_time_idx;

drop index t_point_idx;


create table words (
    word varchar(255) not null
);

\copy words FROM 'C:\Users\sneak\odrive\Google Drive\university\db\2\slovar.csv' DELIMITER '#' CSV

create extension pg_trgm;

CREATE INDEX trgm_idx ON words USING gin (word gin_trgm_ops);


SELECT word, similarity(word, 'aam') AS sml
  FROM words
  WHERE word % 'aam'
  ORDER BY sml DESC, word;

explain
select model, range
from aircrafts
where range > 10000 or range < 4000
;



explain
select *
from aircrafts
where range > 6000
  and substring (model from length(model) - 3 for length(model)) != '100'
;



explain
 select flight_no, scheduled_departure
 from flights
 where  actual_arrival != scheduled_arrival;



explain
 select count(*)
 from flights
 where  status = 'Cancelled'
  and departure_airport = 'LED'
  and extract(dow from scheduled_departure) = 4
  and extract(dow from scheduled_arrival) = 4
 ;


explain
 select tickets.passenger_name
 from tickets full join ticket_flights
 on ticket_flights.ticket_no = tickets.ticket_no
 where ticket_flights.amount > 70000 and fare_conditions = 'Economy'
 ;



explain
select tickets.passenger_name, flights.departure_airport,
  flights.arrival_airport,  flights.scheduled_departure,
  flights.scheduled_arrival, boarding_passes.seat_no
from tickets
  join ticket_flights on tickets.ticket_no = ticket_flights.ticket_no
  join flights on ticket_flights.flight_id = flights.flight_id
  join boarding_passes on tickets.ticket_no = boarding_passes.ticket_no
where flights.status = 'Scheduled'
;



explain
select tickets.passenger_name, flights.flight_no
from tickets
  left join boarding_passes on tickets.ticket_no = boarding_passes.ticket_no
  join ticket_flights on ticket_flights.ticket_no = tickets.ticket_no
  join flights on flights.flight_id = ticket_flights.flight_id
where flights.scheduled_departure = bookings.now() and boarding_passes.seat_no is null
;


explain
select seats.seat_no, flights.flight_no, flights.scheduled_departure
from flights
  join aircrafts on flights.aircraft_code = aircrafts.aircraft_code
  join seats on aircrafts.aircraft_code = seats.aircraft_code
  left join boarding_passes on flights.flight_id = boarding_passes.flight_id
where flights.departure_airport = 'AAQ'
  and flights.arrival_airport = 'SVO'
  and boarding_passes.seat_no is null
;


explain
select avg(ticket_flights.amount)
from ticket_flights
  join flights on ticket_flights.flight_id = flights.flight_id
where departure_airport = 'VOZ' and arrival_airport = 'LED'
;




explain
select fare_conditions, avg(amount)
from ticket_flights
group by fare_conditions
;



explain
select aircrafts.model, count(seats.seat_no)
from seats
  left join aircrafts on seats.aircraft_code = aircrafts.aircraft_code
group by aircrafts.model
;



explain
select airport_name, count(flights.arrival_airport)
from airports
  right join flights on airports.airport_code = flights.arrival_airport
group by airport_name
having count(flights.arrival_airport) > 500
;



explain
select model
from aircrafts
where aircraft_code in (
  select aircraft_code
  from flights
  where actual_arrival - actual_departure > interval '6 hours'
);


explain
select count(*)
from flights
where actual_departure - scheduled_departure > interval '4 hours'
  and actual_departure is not null
;


explain
select arr_pass + dep_pass as productivity, airport_name
from (
  select avg(sub2.cnt_pass) as arr_pass, arrival_airport
  from (
    select count(*) as cnt_pass, arrival_airport, date_trunc('day', actual_arrival) as day
    from ticket_flights
      join flights on flights.flight_id = ticket_flights.flight_id
    where  actual_arrival is not null
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
      where  actual_departure is not null
      group by departure_airport, day
      order by departure_airport
    ) as sub1
    group by departure_airport
    ) as dep on arr.arrival_airport = dep.departure_airport
  join airports on airports.airport_code = arr.arrival_airport
order by productivity desc
limit 10
;



explain
with t as (
  select lead(actual_departure, 1) over() - actual_departure as delay
  from (
    select actual_departure
    from flights
    where departure_airport = 'SVO' and actual_departure is not null
    order by actual_departure
  )as sub1
)
select count(*)
from t
where delay < interval '5 minutes'
;
