create type t as
(
    val   real,
    scale char
);

create domain temperature as t
    check (
            (value::t).scale ~ 'K|C|R|F' and
            (
                    ((value::t).scale = 'K' and (value::t).val >= 0) or
                    ((value::t).scale = 'C' and (value::t).val >= -273.15) or
                    ((value::t).scale = 'R' and ((value::t).val / 0.8) >= -273.15) or
                    ((value::t).scale = 'F' and ((value::t).val - 32) / 1.8 >= -273.15)
                )

        );

select '(1,C)'::temperature;
select '(-1,C)'::temperature;
select '(-300,C)'::temperature;
select '(1,K)'::temperature;
select '(-1,K)'::temperature;
select '(0,K)'::temperature;
select '(1,R)'::temperature;
select '(1,F)'::temperature;
select '(1,E)'::temperature;

-------------------------------------------------------------------------------------------
create type passenger as
(
    ticket_no      char(13),
    book_ref       char(6),
    passenger_id   varchar(20),
    passenger_name text,
    contact_data   jsonb
);

create type flight as
(
    flight_id           integer,
    flight_no           char(6),
    scheduled_departure timestamptz,
    scheduled_arrival   timestamptz,
    departure_airport   char(3),
    arrival_airport     char(3),
    status              varchar(20),
    aircraft_code       char(3),
    actual_departure    timestamptz,
    actual_arrival      timestamptz
);

create type booktype as
(
    book_ref     char(6),
    book_date    timestamptz,
    total_amount numeric(10, 2),
    passengers   passenger[],
    flights      flight[]
);

---------------------------------------------------

