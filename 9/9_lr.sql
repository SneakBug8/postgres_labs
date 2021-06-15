-- 1
SELECT ts_rank(to_tsvector(body), plainto_tsquery('washington')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('washington')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('washington')) DESC;


-- 2
SELECT ts_rank(to_tsvector(body), plainto_tsquery('picture')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('picture')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('picture')) DESC;


-- 3
SELECT ts_rank(to_tsvector(body), plainto_tsquery('siren')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('siren')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('siren')) DESC;

-- 4
SELECT ts_rank(to_tsvector(body), plainto_tsquery('hillary')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('hillary')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('hillary')) DESC;


-- 5
SELECT ts_rank(to_tsvector(body), plainto_tsquery('trump')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('trump')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('trump')) DESC;


-- 6
SELECT ts_rank(to_tsvector(body), plainto_tsquery('biden')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('biden')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('biden')) DESC;


-- 7
SELECT ts_rank(to_tsvector(body), plainto_tsquery('state')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('state')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('state')) DESC;


-- 8
SELECT ts_rank(to_tsvector(body), plainto_tsquery('senator')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('senator')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('senator')) DESC;


-- 9
SELECT ts_rank(to_tsvector(body), plainto_tsquery('house')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('house')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('house')) DESC;


-- 10
SELECT ts_rank(to_tsvector(body), plainto_tsquery('iraq')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('iraq')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('iraq')) DESC;


-- 11
SELECT ts_rank(to_tsvector(body), plainto_tsquery('iran')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('iran')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('iran')) DESC;


-- 12
SELECT ts_rank(to_tsvector(body), plainto_tsquery('russia')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('russia')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('russia')) DESC;


-- 13
SELECT ts_rank(to_tsvector(body), plainto_tsquery('oil')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('oil')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('oil')) DESC;


-- 14
SELECT ts_rank(to_tsvector(body), plainto_tsquery('dollar')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('dollar')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('dollar')) DESC;


-- 15
SELECT ts_rank(to_tsvector(body), plainto_tsquery('britain')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('britain')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('britain')) DESC;


-- 16
SELECT ts_rank(to_tsvector(body), plainto_tsquery('president')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('president')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('president')) DESC;



-- 17
SELECT ts_rank(to_tsvector(body), plainto_tsquery('california')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('california')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('california')) DESC;


-- 18
SELECT ts_rank(to_tsvector(body), plainto_tsquery('NY')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('NY')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('NY')) DESC;


-- 19
SELECT ts_rank(to_tsvector(body), plainto_tsquery('texas')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('texas')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('texas')) DESC;


-- 20
SELECT ts_rank(to_tsvector(body), plainto_tsquery('BBC')), body
FROM texts
WHERE to_tsvector(body) @@ plainto_tsquery('BBC')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('BBC')) DESC;

--------------------------------------------------------------------------------------

create index ind ON texts using gin (to_tsvector('english', body));

alter table texts
    add column vect tsvector;

update texts set vect = to_tsvector(body) where true;

--------------------------------------------------------------------------------------

-- 1
SELECT ts_rank(vect, plainto_tsquery('запрос')), body
FROM texts
WHERE vect @@ plainto_tsquery('запрос')
ORDER BY ts_rank(vect, plainto_tsquery('запрос')) DESC;


-- 2
SELECT ts_rank(vect, plainto_tsquery('какой-нибудь')), body
FROM texts
WHERE vect @@ plainto_tsquery('какой-нибудь')
ORDER BY ts_rank(vect, plainto_tsquery('какой-нибудь')) DESC;


-- 3
SELECT ts_rank(vect, plainto_tsquery('неужели ты не мог обратить свою энергию на розыски')), body
FROM texts
WHERE vect @@ plainto_tsquery('неужели ты не мог обратить свою энергию на розыски')
ORDER BY ts_rank(vect, plainto_tsquery('неужели ты не мог обратить свою энергию на розыски')) DESC;

-- 4
SELECT ts_rank(vect, plainto_tsquery('послышался торопливый голос')), body
FROM texts
WHERE vect @@ plainto_tsquery('послышался торопливый голос')
ORDER BY ts_rank(vect, plainto_tsquery('послышался торопливый голос')) DESC;


-- 5
SELECT ts_rank(vect, plainto_tsquery('дрожал от ярости')), body
FROM texts
WHERE vect @@ plainto_tsquery('дрожал от ярости')
ORDER BY ts_rank(vect, plainto_tsquery('дрожал от ярости')) DESC;


-- 6
SELECT ts_rank(vect, plainto_tsquery('приподнял чуть повыше')), body
FROM texts
WHERE vect @@ plainto_tsquery('приподнял чуть повыше')
ORDER BY ts_rank(vect, plainto_tsquery('приподнял чуть повыше')) DESC;


-- 7
SELECT ts_rank(vect, plainto_tsquery('повернулся и увидел')), body
FROM texts
WHERE vect @@ plainto_tsquery('повернулся и увидел')
ORDER BY ts_rank(vect, plainto_tsquery('повернулся и увидел')) DESC;


-- 8
SELECT ts_rank(vect, plainto_tsquery('но он не закончил своего вопроса')), body
FROM texts
WHERE vect @@ plainto_tsquery('но он не закончил своего вопроса')
ORDER BY ts_rank(vect, plainto_tsquery('но он не закончил своего вопроса')) DESC;


-- 9
SELECT ts_rank(vect, plainto_tsquery('глава двадцать пятая')), body
FROM texts
WHERE vect @@ plainto_tsquery('глава двадцать пятая')
ORDER BY ts_rank(vect, plainto_tsquery('глава двадцать пятая')) DESC;


-- 10
SELECT ts_rank(vect, plainto_tsquery('целых четырнадцать лет')), body
FROM texts
WHERE vect @@ plainto_tsquery('целых четырнадцать лет')
ORDER BY ts_rank(vect, plainto_tsquery('целых четырнадцать лет')) DESC;


-- 11
SELECT ts_rank(vect, plainto_tsquery('сравните время')), body
FROM texts
WHERE vect @@ plainto_tsquery('сравните время')
ORDER BY ts_rank(vect, plainto_tsquery('сравните время')) DESC;


-- 12
SELECT ts_rank(vect, plainto_tsquery('внимательно осмотрел')), body
FROM texts
WHERE vect @@ plainto_tsquery('внимательно осмотрел')
ORDER BY ts_rank(vect, plainto_tsquery('внимательно осмотрел')) DESC;


-- 13
SELECT ts_rank(vect, plainto_tsquery('крохотный золотой ключик')), body
FROM texts
WHERE vect @@ plainto_tsquery('крохотный золотой ключик')
ORDER BY ts_rank(vect, plainto_tsquery('крохотный золотой ключик')) DESC;


-- 14
SELECT ts_rank(vect, plainto_tsquery('получил письмо')), body
FROM texts
WHERE vect @@ plainto_tsquery('получил письмо')
ORDER BY ts_rank(vect, plainto_tsquery('получил письмо')) DESC;


-- 15
SELECT ts_rank(vect, plainto_tsquery('врезался в дерево')), body
FROM texts
WHERE vect @@ plainto_tsquery('врезался в дерево')
ORDER BY ts_rank(vect, plainto_tsquery('врезался в дерево')) DESC;


-- 16
SELECT ts_rank(vect, plainto_tsquery('маленький кусочек дерева')), body
FROM texts
WHERE vect @@ plainto_tsquery('маленький кусочек дерева')
ORDER BY ts_rank(vect, plainto_tsquery('маленький кусочек дерева')) DESC;



-- 17
SELECT ts_rank(vect, plainto_tsquery('одиноко стояло')), body
FROM texts
WHERE vect @@ plainto_tsquery('одиноко стояло')
ORDER BY ts_rank(vect, plainto_tsquery('одиноко стояло')) DESC;


-- 18
SELECT ts_rank(vect, plainto_tsquery('под сенью густой листвы')), body
FROM texts
WHERE vect @@ plainto_tsquery('под сенью густой листвы')
ORDER BY ts_rank(vect, plainto_tsquery('под сенью густой листвы')) DESC;


-- 19
SELECT ts_rank(vect, plainto_tsquery('она приспособилась')), body
FROM texts
WHERE vect @@ plainto_tsquery('она приспособилась')
ORDER BY ts_rank(vect, plainto_tsquery('она приспособилась')) DESC;


-- 20
SELECT ts_rank(vect, plainto_tsquery('опрокинул лампу')), body
FROM texts
WHERE vect @@ plainto_tsquery('опрокинул лампу')
ORDER BY ts_rank(vect, plainto_tsquery('опрокинул лампу')) DESC;

------------------------------------------------------------------------------------
select *
from texts2;



-- 1
SELECT ts_rank(to_tsvector(body), plainto_tsquery('which came in very useful')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('which came in very useful')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('which came in very useful')) DESC;


-- 2
SELECT ts_rank(to_tsvector(body), plainto_tsquery('какой-нибудь')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('какой-нибудь')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('какой-нибудь')) DESC;


-- 3
SELECT ts_rank(to_tsvector(body), plainto_tsquery('deserved whet she got')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('deserved whet she got')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('deserved whet she got')) DESC;

-- 4
SELECT ts_rank(to_tsvector(body), plainto_tsquery('послышался торопливый голос')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('послышался торопливый голос')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('послышался торопливый голос')) DESC;


-- 5
SELECT ts_rank(to_tsvector(body), plainto_tsquery('loud puffing sound')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('loud puffing sound')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('loud puffing sound')) DESC;


-- 6
SELECT ts_rank(to_tsvector(body), plainto_tsquery('приподнял чуть повыше')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('приподнял чуть повыше')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('приподнял чуть повыше')) DESC;


-- 7
SELECT ts_rank(to_tsvector(body), plainto_tsquery('повернулся и увидел')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('повернулся и увидел')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('повернулся и увидел')) DESC;


-- 8
SELECT ts_rank(to_tsvector(body), plainto_tsquery('was behind him')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('was behind him')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('was behind him')) DESC;


-- 9
SELECT ts_rank(to_tsvector(body), plainto_tsquery('глава двадцать пятая')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('глава двадцать пятая')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('глава двадцать пятая')) DESC;


-- 10
SELECT ts_rank(to_tsvector(body), plainto_tsquery('she stopped before')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('she stopped before')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('she stopped before')) DESC;


-- 11
SELECT ts_rank(to_tsvector(body), plainto_tsquery('сравните время')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('сравните время')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('сравните время')) DESC;


-- 12
SELECT ts_rank(to_tsvector(body), plainto_tsquery('внимательно осмотрел')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('внимательно осмотрел')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('внимательно осмотрел')) DESC;


-- 13
SELECT ts_rank(to_tsvector(body), plainto_tsquery('крохотный золотой ключик')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('крохотный золотой ключик')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('крохотный золотой ключик')) DESC;


-- 14
SELECT ts_rank(to_tsvector(body), plainto_tsquery('получил письмо')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('получил письмо')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('получил письмо')) DESC;


-- 15
SELECT ts_rank(to_tsvector(body), plainto_tsquery('the closed door')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('the closed door')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('the closed door')) DESC;


-- 16
SELECT ts_rank(to_tsvector(body), plainto_tsquery('маленький кусочек дерева')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('маленький кусочек дерева')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('маленький кусочек дерева')) DESC;



-- 17
SELECT ts_rank(to_tsvector(body), plainto_tsquery('одиноко стояло')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('одиноко стояло')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('одиноко стояло')) DESC;


-- 18
SELECT ts_rank(to_tsvector(body), plainto_tsquery('под сенью густой листвы')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('под сенью густой листвы')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('под сенью густой листвы')) DESC;


-- 19
SELECT ts_rank(to_tsvector(body), plainto_tsquery('она приспособилась')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('она приспособилась')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('она приспособилась')) DESC;


-- 20
SELECT ts_rank(to_tsvector(body), plainto_tsquery('опрокинул лампу')), body
FROM texts2
WHERE to_tsvector(body) @@ plainto_tsquery('опрокинул лампу')
ORDER BY ts_rank(to_tsvector(body), plainto_tsquery('опрокинул лампу')) DESC;


create index ind_rus ON texts2 using gin (to_tsvector('russian', body));
create index ind_eng ON texts2 using gin (to_tsvector('english', body));

alter table texts2
    add column vect tsvector;

update texts2 set vect = to_tsvector(body) where true;

-----------------------------------------------------------

create table text_bookings
(
    body text
);

insert into text_bookings
select 'Отправление: ' || scheduled_departure ||
       ' Прибытие: ' || scheduled_arrival ||
       ' Следеует из ' || apd.city || ' (' || apd.airport_code || ')'
           ' Следует в ' || apa.city || ' (' || apa.airport_code || ')'
           ' Самолет: ' || ac.model
from flights as f
         left join airports as apd on departure_airport = apd.airport_code
         left join airports as apa on arrival_airport = apa.airport_code
         left join aircrafts as ac on f.aircraft_code = ac.aircraft_code;


create index ind_gin on text_bookings using gin (to_tsvector('russian', body));

create index ind1 on flights (scheduled_departure, departure_airport, arrival_airport);

select ts_rank(to_tsvector(body), plainto_tsquery('Следует из SVO Отправление 2017-09-12')), body
from text_bookings
where to_tsvector(body) @@ plainto_tsquery('Следует из SVO Отправление 2017-09-12')
order by ts_rank(to_tsvector(body), plainto_tsquery('Следует из SVO Отправление 2017-09-12')) DESC;

select *
from flights
where departure_airport = 'SVO' and date_trunc('day', scheduled_departure) = '2017-09-12';
