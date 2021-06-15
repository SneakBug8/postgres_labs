pg_dump -U postgres -C demo > C:\db.sql

drop database demo;
create database demo;

demo < C:\db.sql


begin ;
update tickets set passenger_name = 'name' where passenger_name = 'VALERIY TIKHONOV';
commit ;

begin ;
update tickets set passenger_name = 'name' where passenger_name = 'ARTUR GERASIMOV';
commit ;


select *
from tickets where passenger_name = 'name';