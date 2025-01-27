select * from emp;

drop table emp;

CREATE TYPE designation_enum AS ENUM ('Programmer', 'Tester', 'Admin', 'Manager');


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