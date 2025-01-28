-- EMPLOYEE
	--EID (Primary Key)
	--NAME
	--AGE (21 to 60)
	--GENDER (MALE/FEMALE)
	--SALARY (999999.99)
	--DESIGNATION (PROGRAMMER/TESTER/ADMIN/MANAGER)
	--MGR_ID (Pointing to EID)
	--EMAIL_ID (abc@xyz.com)
	--MARRIED (true/false)
	--JOINING_DATE (current_date by default)


select * from employees;

drop table emp;

CREATE TYPE designation_enum AS ENUM ('Programmer', 'Tester', 'Admin', 'Manager');
ALTER TYPE designation_enum ADD VALUE 'Clerk';



CREATE TABLE employees(
	eid SERIAL PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	age SMALLINT,
	gender VARCHAR(15) NOT NULL,
	salary NUMERIC(8, 2) DEFAULT 15000.00,
	designation designation_enum NOT NULL,
	email_id VARCHAR(255) NOT NULL,
	married BOOLEAN NOT NULL,
	joining_date DATE DEFAULT CURRENT_DATE,
	manager_id int,
	
	CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES employees (eid),
	CONSTRAINT check_email_id CHECK(email_id ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
	CONSTRAINT check_age CHECK(age>=21 AND age<=60),
	CONSTRAINT check_gender CHECK(gender IN ('Male', 'Female'))
);

INSERT INTO employees (name, age, gender, salary, designation, email_id, married, joining_date)
VALUES ('Alice Johnson', 35, 'Female', 25000.00, 'Manager', 'alice.johnson@example.com', TRUE, '2025-01-01');

INSERT INTO employees (name, age, gender, salary, designation, email_id, married, joining_date, manager_id)
VALUES ('Bob Smith', 28, 'Male', 20000.00, 'Tester', 'bob.smith@example.com', FALSE, '2025-01-10', 1); 

SELECT * FROM employees;

INSERT INTO employees (name, age, gender, salary, designation, email_id, married, joining_date, manager_id)
VALUES
	('Bob Smith', 28, 'Male', 25000.00, 'Programmer', 'bob.smith@example.com', FALSE, CURRENT_DATE, 1),
    ('Charlie Brown', 32, 'Male', 22000.00, 'Tester', 'charlie.brown@example.com', TRUE, CURRENT_DATE, 1),
    ('Diana White', 30, 'Female', 26000.00, 'Programmer', 'diana.white@example.com', FALSE, CURRENT_DATE, 1),
    
    -- Admin Reporting to Alice
    ('Eve Green', 35, 'Female', 28000.00, 'Admin', 'eve.green@example.com', TRUE, CURRENT_DATE, 1),
    
    -- New Manager (No Manager Reference)
    ('Frank Black', 45, 'Male', 35000.00, 'Manager', 'frank.black@example.com', TRUE, CURRENT_DATE, NULL),
    
    -- Employees Reporting to Frank (Manager with eid = 6)
    ('Grace Adams', 27, 'Female', 24000.00, 'Tester', 'grace.adams@example.com', FALSE, CURRENT_DATE, 6),
    ('Henry Ford', 29, 'Male', 23000.00, 'Programmer', 'henry.ford@example.com', FALSE, CURRENT_DATE, 6),
    ('Ivy Nelson', 31, 'Female', 27000.00, 'Admin', 'ivy.nelson@example.com', TRUE, CURRENT_DATE, 6),
    
    -- Another Tester Reporting to Bob (eid = 2)
    ('Jack Brown', 26, 'Male', 21000.00, 'Tester', 'jack.brown@example.com', FALSE, CURRENT_DATE, 2);


select * from employees where age between 30 and 35;
select * from employees where name like '%a';
select * from employees where name like 'a%';
select * from employees where name like '%a%';

select * from employees limit 5; -- will get me only 5 records, this is limiting(or for pagination kind of emulation)
select * from employees limit 5 offset 3; -- skip first 3
select * from employees offset 3 limit 5; -- offset before limit also fine


-- String functions
select upper(name), age from employees;
select reverse('Madam') = 'Madam';

select reverse('MadaM');

select current_date;

create table role (designation varchar(20) primary key, max_limit integer, min_salary integer );

insert into role values
('Tester', 100, 20000),
('Programmer', 200, 30000),
('Manager', 15, 120000),
('Clerk', 50, 25000);

select * from role;


SELECT e.name, e.designation, e.salary, r.min_salary, r.max_limit
FROM employees e
JOIN role r ON e.designation = r.designation;


-- Step 1: Add a temporary column to preserve existing data
ALTER TABLE role ADD COLUMN temp_designation VARCHAR(20);

-- Step 2: Copy data from the old column to the temporary column
UPDATE role SET temp_designation = designation;

-- Step 3: Drop the old designation column
ALTER TABLE role DROP COLUMN designation;

-- Step 4: Add a new designation column with type designation_enum
ALTER TABLE role ADD COLUMN designation designation_enum;

-- Step 5: Copy data back from the temporary column to the new column
UPDATE role SET designation = temp_designation::designation_enum;

-- Step 6: Drop the temporary column
ALTER TABLE role DROP COLUMN temp_designation;




SELECT 
    e.name, 
    e.salary, 
    m.name AS manager_name, 
    m.salary AS manager_salary
FROM 
    employees e
JOIN 
    employees m 
ON 
    e.manager_id = m.eid
WHERE 
    e.salary > m.salary;

select designation, sum(salary) from employees group by designation;
select designation, sum(salary) from employees group by rollup(designation);
select designation, sum(salary) from employees group by rollup(designation) order by sum(salary);
 ;
SELECT 
    COALESCE(designation::varchar(50), 'Total') AS designation,
    SUM(salary) AS total_salary
FROM 
    employees
GROUP BY 
    ROLLUP(designation)
ORDER BY 
    SUM(salary);


CREATE OR REPLACE PROCEDURE insert_emp_record(
    e_name VARCHAR(15),
    e_age SMALLINT,
    e_salary NUMERIC,
    e_desig designation_enum,
    e_gender VARCHAR(10),
    e_email_id VARCHAR(50),
    e_married BOOLEAN,
    e_manager_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees(name, age, salary, designation, gender, email_id, married, manager_id)
    VALUES (e_name, e_age, e_salary, e_desig, e_gender, e_email_id, e_married, e_manager_id);
END;
$$;

CALL insert_emp_record(
    'Jonathan'::VARCHAR(15),       -- Explicit cast to VARCHAR(15)
    34::SMALLINT,                 -- Explicit cast to SMALLINT
    20000::NUMERIC,               -- Explicit cast to NUMERIC
    'Manager'::designation_enum,  -- Explicit cast to designation_enum
    'Male'::VARCHAR(10),          -- Explicit cast to VARCHAR(10)
    'jonathandabre01@gmail.com'::VARCHAR(50),  -- Explicit cast to VARCHAR(50)
    TRUE::BOOLEAN,                -- Explicit cast to BOOLEAN
    1::INT                        -- Explicit cast to INT
);



drop procedure abc();


create or replace procedure appraisal(
	id int,
	amount int
)
language plpgsql
as $$
begin
	update employees set salary=salary+amount where eid=id;
end;
$$


select * from employees;

call appraisal(1, 25000);


create or replace function max_salary(desig designation_enum)
returns table(eid int, name varchar, salary decimal)
as $$
begin 
	return query
	select e.eid, e.name, e.salary from employees e where e.designation = desig
	and e.salary = (select max(e2.salary) from employees e2
	where e2.designation = desig);
end;
$$ language plpgsql;

drop function max_salary;

select * from max_salary('Manager':: designation_enum);
select * from max_salary('Tester':: designation_enum);

-- Windows operating system specific functions

select name, salary, sum(salary) over(order by salary) from employees;

select row_number() over(order by name), name, designation, salary from employees;

select name, salary, rank() over(order by salary desc) from employees;

select name, salary, dense_rank() over(order by salary desc) from employees;

select name, salary, lag(salary) over() from employees;

select name, salary, lead(salary) over() from employees;


-- ----

select e.name, e.salary, e.designation 
from employees e
where e.salary> (
	select avg(e2.salary)
	from employees e2
	where e2.designation = e.designation
)
order by e.designation, e.salary desc;



with avg_salary as(
select designation, avg(salary) as avg_salary from emp group by designation;
)


create or replace function validate_salary()
returns trigger as $$
begin 
	if new.salary<120000 then 
		new.salary = 12000;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger update_emp_trigger 
before update on employees
for each row 
execute function validate_salary();


select * from employees;

update employees set salary = 5000 where eid=2;









