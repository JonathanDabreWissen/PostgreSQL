insert into EMP values
('Raju', 25),
('Suman', 33),
('Ganesh', 27),
('Anusha', 38)

select * from EMP;

delete from EMP;

select datname from pg_database;

select * from pg_database;


create table emp(
	eid int primary key,
	name varchar(15) not null,
	age smallint,
	salary decimal(8, 2) default 15000.00,
	designation varchar(20) not null 
);

drop table emp;

create table emp(
	eid serial primary key,
	name varchar(15) not null,
	age smallint,
	salary decimal(8, 2) default 15000.00,
	designation varchar(20) not null 
);

insert into EMP (NAME, AGE, SALARY, DESIGNATION) values('Raju', 25, 30000, 'Tester');

insert into EMP (NAME, AGE, SALARY, DESIGNATION) values
	('Manju', 38, 30000, 'Programmer'),
	('Sanju', 41, 120000, 'Programmer'),
	('Daniel', 25, 30000, 'Tester'),
	('Sunil', 35, 30000, 'Tester');

insert into EMP (NAME, AGE, SALARY, DESIGNATION) values
	('Manju', 38, 30000, 'Programmer'),
	('Sanju', 41, 120000, 'Programmer'),
	('Daniel', 25, 30000, 'Tester'),
	('Sunil', 35, 30000, 'Tester');

insert into EMP (NAME, AGE, DESIGNATION) values
	('Manisha', 21, 'Programmer');
	