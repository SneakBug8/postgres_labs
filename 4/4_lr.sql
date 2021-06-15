create table lab4 (
    side text
);



begin;

set transaction isolation level read committed ;

insert into lab4 values ('left');

-- в этом месте нужно выполнить запросы из другой транзакции

select * from lab4;
------------------------------ в разных консолях ---------------------

begin;

set transaction isolation level read committed ;

insert into lab4 values ('right');

commit;

----------------
delete from lab4;
----------------


begin;

set transaction isolation level serializable ;

insert into lab4 values ('left');

-- в этом месте нужно выполнить запросы из другой транзакции

select * from lab4;
------------------------------ в разных консолях ---------------------

begin;

set transaction isolation level serializable ;

insert into lab4 values ('right');

commit;



------------------
------------------
------------------

-- комманды выполняются через одну 
-- из разных транзакций, в разных консолях

--------------------------------------------

begin;
set transaction isolation level serializable;

select * from x;

update y SET cmn = 2 where true;

commit;
--------------------------------------------
begin;
set transaction isolation level serializable;

select * from y;

update x set cmn = 2 where true;

commit ;
--------------------------------------------

--------------------------------------------
--------------------------------------------

select y.*, x.*
from x join y on true;

-- в комментариях запросы из второй транзакции,
-- добавлены чтобы понимать порядок выполнения запросов

begin isolation level repeatable read ;
-- begin isolation level repeatable read ;

update y set cmn = cmn + (select * from x) where true;
-- update x set cmn = cmn + (select * from y) where true;

commit;
-- commit;

--------------------------------------------

begin isolation level repeatable read ;

update x set cmn = cmn + (select * from y) where true;

commit;

--------------------------------------------
--------------------------------------------


create table z (tbl varchar(1), value int);
update x set cmn = 1 where true;
update y set cmn = 1 where true;
delete from z where true;
--------------------------------------------
begin isolation level repeatable read;
-- begin isolation level repeatable read;

-- insert into z values ('x', (select * from x)),('y', (select * from y));

update y set cmn = cmn + (select * from y) where true;

commit;

begin isolation level repeatable read;

select y.*, x.* from x join y on true;

commit;

-- update x
-- set cmn = cmn +
--     (select value from z where tbl = 'x') +
--     (select value from z where tbl = 'y')
-- where true;

-- commit;

--------------------------------------------

begin isolation level repeatable read;

insert into z values ('x', (select * from x)),('y', (select * from y));


update x
set cmn = cmn +
    (select value from z where tbl = 'x') +
    (select value from z where tbl = 'y')
where true;

commit;
-------------------------------------------
-------------------------------------------