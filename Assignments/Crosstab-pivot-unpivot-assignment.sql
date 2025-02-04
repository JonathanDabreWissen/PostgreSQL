create table sales(
	product text,
	month text,
	sales_amount int
);

INSERT INTO sales (product, month, sales_amount) VALUES
('Product A', 'January', 100),
('Product B', 'January', 150),
('Product A', 'February', 200),
('Product B', 'February', 250),
('Product A', 'March', 300),
('Product B', 'March', 350);


-- Insert additional data into the sales table
INSERT INTO sales (product, month, sales_amount) VALUES
('Product A', 'April', 400),
('Product B', 'April', 450),
('Product C', 'January', 120),
('Product C', 'February', 180),
('Product C', 'March', 220),
('Product C', 'April', 270),
('Product D', 'January', 80),
('Product D', 'February', 130),
('Product D', 'March', 170),
('Product D', 'April', 200),
('Product E', 'January', 50),
('Product E', 'February', 75),
('Product E', 'March', 110),
('Product E', 'April', 150);

-- Install tablefunc extension (if not already installed)
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM sales ORDER BY product, month;


--Pivot data using crosstab
SELECT *
FROM crosstab(
    'SELECT product, month, sales_amount FROM sales ORDER BY 1, 2', 
    'SELECT DISTINCT month FROM sales ORDER BY 1'
) AS ct(product TEXT, January INT, February INT, March INT, April INT);


-- Create a table to store the pivoted data
CREATE TABLE sales_pivoted (
    product TEXT PRIMARY KEY,
    January INT,
    February INT,
    March INT,
    April INT
);


-- Insert pivoted into pivoted table
INSERT INTO sales_pivoted
SELECT * FROM crosstab(
    'SELECT product, month, sales_amount FROM sales ORDER BY 1, 2', 
    'SELECT DISTINCT month FROM sales ORDER BY 1'
) AS ct(product TEXT, January INT, February INT, March INT, April INT);


-- Unpivot the data
SELECT product, 'January' AS month, January AS sales_amount FROM sales_pivoted
UNION ALL
SELECT product, 'February', February FROM sales_pivoted
UNION ALL
SELECT product, 'March', March FROM sales_pivoted
UNION ALL
SELECT product, 'April', April FROM sales_pivoted;



-- Total sales per product
SELECT product, SUM(sales_amount) AS total_sales 
FROM sales 
GROUP BY product 
ORDER BY total_sales DESC;

-- Total sales per month
SELECT month, SUM(sales_amount) AS total_sales 
FROM sales 
GROUP BY month 
ORDER BY total_sales DESC;


-- Find the Best-Selling Product per Month
SELECT month, product, sales_amount
FROM (
    SELECT month, product, sales_amount, 
           RANK() OVER (PARTITION BY month ORDER BY sales_amount DESC) AS rank
    FROM sales
) ranked
WHERE rank = 1;


-- Find month with best sales
SELECT month, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;


-- Drop table
drop table sales;



