select rolname
from pg_roles;
-----------------------------------------------------------------
create role read_role nologin;
grant usage on schema bookings to read_role;
grant select on all tables in schema bookings to read_role;
-----------------------------------------------------------------
create user reader with password '0000' in role read_role;

select *
from tickets;
insert into bookings
values ('qqqqqq', '2017-07-29 03:30:00.000000', 123);

----------------------------------------------------------------

revoke all on all tables in schema bookings from read_role;
revoke usage on schema bookings from read_role;
drop role read_role;
drop user reader;

create role read_role nologin;
-- grant usage on schema bookings to read_role;
grant select on all tables in schema bookings to read_role;

create user reader with password '0000' in role read_role;

----------------------------------------------------------------
create table tbl
(
    usr  text,
    body text
);
alter table tbl
    enable ROW LEVEL SECURITY;

create policy p on tbl for all
    using (usr = current_user)
    with check (usr = current_user);

create user usr1 password '0000';
create user usr2 password '0000';
grant connect on DATABASE demo to usr1, usr2;
grant usage on SCHEMA bookings to usr1, usr2;
grant all on table tbl to usr1, usr2;

insert into tbl
values ('usr1', 'record 1'),
       ('usr2', 'record 2');


revoke connect on DATABASE demo from usr1, usr2;
revoke usage on SCHEMA bookings from usr1, usr2;
revoke all on table tbl from usr1, usr2;
drop user usr1;
drop user usr2;
drop table tbl;

----------------------------------------------------------

create table tbl
(
    lvl  integer,
    body text
);
alter table tbl
    enable ROW LEVEL SECURITY;

create table usr_lvl
(
    usr text primary key,
    lvl integer
);

create user usr_public password '0000';
create user usr_private password '0000';
create user usr_secret password '0000';
grant connect on DATABASE demo to usr_public, usr_private, usr_secret;
grant usage on SCHEMA bookings to usr_public, usr_private, usr_secret;
grant all on table tbl, usr_lvl to usr_public, usr_private, usr_secret;

insert into usr_lvl
values ('usr_public', 3),
       ('usr_private', 2),
       ('usr_secret', 1);

create policy p on tbl for all
    using (
        lvl >= (select ul.lvl
                from usr_lvl as ul
                where ul.usr = current_user)
    )
    with check (
        lvl >= (select ul.lvl
                from usr_lvl as ul
                where ul.usr = current_user)
    );


insert into tbl
values (1, 'Совершенно секреная запись'),
       (1, 'Совершенно секреная запись'),
       (1, 'Совершенно секреная запись'),
       (1, 'Совершенно секреная запись'),
       (1, 'Совершенно секреная запись'),
       (2, 'Секретная запись'),
       (2, 'Секретная запись'),
       (2, 'Секретная запись'),
       (2, 'Секретная запись'),
       (2, 'Секретная запись'),
       (3, 'Открытый доступ'),
       (3, 'Открытый доступ'),
       (3, 'Открытый доступ'),
       (3, 'Открытый доступ'),
       (3, 'Открытый доступ');

