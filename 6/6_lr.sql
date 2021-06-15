----------------------------------------------------------------------------------------------
-------------------------------------15.1-----------------------------------------------------
----------------------------------------------------------------------------------------------


with recursive r as (
    select ('{' || departure_airport || ',' || arrival_airport || '}')::char(3)[] as cities,
           interval '48 hours'                                                    as duration,
           scheduled_departure                                                    as dep_time
    from flights
    where arrival_airport = 'SVO'
       or arrival_airport = 'VKO'
       or arrival_airport = 'DME'
    union
    select distinct on (cities) (flights.departure_airport || r.cities)::char(3)[] as cities,
                                duration - (r.dep_time - flights.scheduled_arrival) -
                                (flights.scheduled_arrival - flights.scheduled_departure)
                                                                                   as duration,
                                flights.scheduled_departure                        as dep_time
    from flights
             join r on cities[1] = flights.arrival_airport
        and (r.dep_time - flights.scheduled_arrival > interval '1 hours')
        and (r.dep_time - flights.scheduled_arrival < interval '24 hours')
        and array_position(cities, flights.departure_airport) is null
    where duration - (r.dep_time - flights.scheduled_arrival) -
          (flights.scheduled_arrival - flights.scheduled_departure) > interval '0'
)
select r.cities, r.duration
from r
where array_length(r.cities, 1) > 2
;

----------------------------------------------------------------------------------------------
-------------------------------------15.2-----------------------------------------------------
----------------------------------------------------------------------------------------------


with recursive r as (
    select ('{' || departure_airport || ',' || arrival_airport || '}')::char(3)[] as cities,
           interval '48 hours'                                                    as duration,
           scheduled_departure                                                    as dep_time
    from flights
    where arrival_airport = 'SVO'
       or arrival_airport = 'VKO'
       or arrival_airport = 'DME'
    union
    select distinct on (cities) (flights.departure_airport || r.cities)::char(3)[] as cities,
                                duration - (r.dep_time - flights.scheduled_arrival) -
                                (flights.scheduled_arrival - flights.scheduled_departure)
                                                                                   as duration,
                                flights.scheduled_departure                        as dep_time
    from flights
             join r on cities[1] = flights.arrival_airport
        and (r.dep_time - flights.scheduled_arrival > interval '1 hours')
        and (r.dep_time - flights.scheduled_arrival < interval '24 hours')
        and array_position(cities, flights.departure_airport) is null
    where duration - (r.dep_time - flights.scheduled_arrival) -
          (flights.scheduled_arrival - flights.scheduled_departure) > interval '0'
)
select r.cities as path
from r
where array_length(r.cities, 1) > 2
  and r.cities[1] not in (select distinct departure_airport
                          from flights
                          where arrival_airport = 'SVO'
                             or arrival_airport = 'DME'
                             or arrival_airport = 'VKO')
;

----------------------------------------------------------------------------------------------
-------------------------------------15.3-----------------------------------------------------
----------------------------------------------------------------------------------------------

with recursive r as (
    select ('{' || departure_airport || ',' || arrival_airport || '}')::char(3)[] as cities,
           interval '48 hours'                                                    as duration,
           scheduled_departure                                                    as dep_time,
           0::numeric                                                             as amount_transfer
    from flights
    where arrival_airport = 'SVO'
       or arrival_airport = 'VKO'
       or arrival_airport = 'DME'
    union
    select distinct on (cities) (flights.departure_airport || r.cities)::char(3)[] as cities,
                                duration - (r.dep_time - flights.scheduled_arrival) -
                                (flights.scheduled_arrival - flights.scheduled_departure)
                                                                                   as duration,
                                flights.scheduled_departure                        as dep_time,
                                r.amount_transfer + tf.amount                      as total
    from flights
             join r on cities[1] = flights.arrival_airport
        and (r.dep_time - flights.scheduled_arrival > interval '1 hours')
        and (r.dep_time - flights.scheduled_arrival < interval '24 hours')
        and array_position(cities, flights.departure_airport) is null
             join ticket_flights tf on flights.flight_id = tf.flight_id
    where duration - (r.dep_time - flights.scheduled_arrival) -
          (flights.scheduled_arrival - flights.scheduled_departure) > interval '0'
)
select pth, amount_transfer, amount
from (select r.cities as pth, r.amount_transfer
      from r
      where array_length(r.cities, 1) > 2
        and r.cities[1] in (
          select distinct departure_airport
          from flights
          where (arrival_airport = 'SVO'
              or arrival_airport = 'VKO'
              or arrival_airport = 'DME'))
      limit 1000
     ) as lp
         join (
    select distinct on (departure_airport) amount, departure_airport
    from flights
             join ticket_flights tf on (arrival_airport = 'SVO'
        or arrival_airport = 'VKO'
        or arrival_airport = 'DME')
        and flights.flight_id = tf.flight_id
) as sp
              on lp.pth[1] = sp.departure_airport
where amount_transfer < amount;

----------------------------------------------------------------------------------------------
-------------------------------------15.4-----------------------------------------------------
----------------------------------------------------------------------------------------------


with a as (
    select *
    from flights
)
select a.status
from a
where a.flight_id = '7784';



----------------------------------------------------------------------------------------------
-------------------------------------15.5-----------------------------------------------------
----------------------------------------------------------------------------------------------


create unique index pkey_index on bookings (upper(book_ref));

insert into bookings
values ('abcdef', '2017-07-29 03:30:00.000000', 136200.00);


----------------------------------------------------------------------------------------------
-------------------------------------15.6-----------------------------------------------------
----------------------------------------------------------------------------------------------


create index gone on flights (actual_departure) where actual_departure is not null;

select *
from flights
where actual_departure > '2017-07-16 02:27:00.000000'
  and actual_departure < '2017-07-16 04:08:00.000000';


----------------------------------------------------------------------------------------------
-------------------------------------15.7-----------------------------------------------------
----------------------------------------------------------------------------------------------


with m as (
    select departure_airport as da, arrival_airport as aa, scheduled_departure as sd, count(*) as cnt
    from flights as f
             join ticket_flights tf on f.flight_id = tf.flight_id
    group by f.flight_id
),
     n as (
         select m.da, m.aa, date_trunc('day', m.sd) as day, avg(m.cnt) as avg, count(*) as cnt_today
         from m
         group by m.da, m.aa, day
     )
select m.da as "from", m.aa as "to", m.sd as day, m.cnt as cnt_pass, n.avg as avg_pass_today, n.cnt_today as cnt_today
from m
         join n on m.da = n.da
    and m.aa = n.aa
    and date_trunc('day', m.sd) = n.day
where cnt_today > 1
;


----------------------------------------------------------------------------------------------
-------------------------------------15.8-----------------------------------------------------
----------------------------------------------------------------------------------------------

create materialized view mat as
select departure_airport as da, arrival_airport as aa, scheduled_departure as sd, count(*) as cnt
from flights as f
         join ticket_flights tf on f.flight_id = tf.flight_id
group by f.flight_id;

create materialized view mat2 as
select mat.da, mat.aa, date_trunc('day', mat.sd) as day, avg(mat.cnt) as avg, count(*) as cnt_today
from mat
group by mat.da, mat.aa, day;

select m.da as "from", m.aa as "to", m.sd as day, m.cnt as cnt_pass, n.avg as avg_pass_today, n.cnt_today as cnt_today
from mat as m
         join mat2 as n on m.da = n.da
    and m.aa = n.aa
    and date_trunc('day', m.sd) = n.day
where cnt_today > 1;
