--create database
create database walmart;
-- Create table
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2)
);


select * from Sales

-- Add the time_of_day column
SELECT time,
    (CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM Sales;

ALTER TABLE sales 
ADD  time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
END;


-- Add the day_name column
select date , FORMAT(date, 'dddd') AS day_name
 from Sales

 ALTER TABLE sales 
ADD  day_name VARCHAR(20);

UPDATE sales
SET day_name = FORMAT(date, 'dddd');

-- Add month_name column

ALTER TABLE sales 
ADD  month_name VARCHAR(20);

UPDATE sales
SET month_name = FORMAT(date, 'MMM');

select month_name from Sales

--Exploratory Data Analysis (EDA)
-------------------Generic Question---------------
-- 1-How many unique cities does the data have?
select count(distinct city) as unique_city_count from Sales

-- 2- In which city is each branch?
select distinct city , branch from Sales

----------------Product--------------
-- 1-How many unique product lines does the data have?
select count(distinct Product_line) as unique_product_line_count from Sales

-- 2-What is the most common payment method?
select top(1) payment ,count(payment) as method_count 
from Sales 
group by payment
ORDER BY method_count DESC

-- 3-What is the most selling product line?
select top(1) Product_line ,count(Product_line) as Product_line_count 
from Sales 
group by Product_line
ORDER BY Product_line_count DESC

-- 4-What is the total revenue by month?
select month_name,SUM(total) AS total_revenue
from Sales
group by month_name
order by total_revenue desc 

-- 5-What month had the largest COGS?

select top(1) month_name,SUM(cogs) AS total_cogs
from Sales
group by month_name
order by total_cogs desc 

-- 6-What product line had the largest revenue?
select top(1) Product_line,SUM(total) AS total_revenue
from Sales
group by Product_line
order by total_revenue desc

-- 7-What is the city with the largest revenue?
select top(1) City,SUM(total) AS total_revenue
from Sales
group by City
order by total_revenue desc

-- 8-What product line had the largest VAT?
SELECT TOP (1) product_line, avg(Tax_5) AS total_vat
FROM sales
GROUP BY product_line
ORDER BY total_vat DESC;

-- 9-Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
alter table sales
add sales_category varchar(10)

update Sales
set sales_category =
	case 
	when(SELECT SUM(total) FROM sales s WHERE s.product_line = sales.product_line) > (SELECT AVG(total) FROM Sales) then 'Good'
	else 'Bad'
	end;

select distinct Product_line , sales_category from Sales

-- 10-Which branch sold more products than average product sold?
select  Branch, sum(quantity) as total_quantity 
from Sales
group by Branch
having SUM(quantity) > (select AVG(quantity) from sales)
order by total_quantity desc

-- 11-What is the most common product line by gender?
select Gender, Product_line , COUNT(Gender)  as total_count
from Sales
group by Product_line , Gender
order by total_count desc

-- 12-What is the average rating of each product line?
select Product_line , AVG(Rating) as avg_rating
from Sales
group by Product_line
order by avg_rating desc


----------------Sales--------------

-- 1-Number of sales made in each time of the day per weekday?
select   time_of_day  , count(total) as number_of_sales
from Sales
where day_name = 'sunday'
group by  time_of_day
order by number_of_sales desc

-- 2-Which of the customer types brings the most revenue?
select Customer_type , SUM(total) AS total_revenue
from Sales
group by Customer_type
order by total_revenue desc

-- 3-Which city has the largest tax percent/ VAT (Value Added Tax)?
select City , avg(Tax_5) as VAT 
from Sales
group by City
order by VAT desc

-- 4-Which customer type pays the most in VAT? 
select Customer_type , avg(Tax_5) as VAT 
from Sales
group by Customer_type
order by VAT desc


----------------Customer--------------

-- 1-How many unique customer types does the data have?
select distinct Customer_type
from Sales

-- 2-How many unique payment methods does the data have?
select distinct Payment
from Sales

-- 3-What is the most common customer type?
select Customer_type , count(Customer_type) as customer_count
from Sales
group  by Customer_type
order by customer_count desc

-- 4-Which customer type buys the most?
select Customer_type , sum(Total) as customer_sales
from Sales
group  by Customer_type
order by customer_sales desc

-- 5-What is the gender of most of the customers?
select Gender , count(Gender) as Gender_count
from Sales
group  by Gender
order by Gender_count desc

-- 6-What is the gender distribution per branch?
select Gender , count(Gender) as Gender_count
from Sales
where branch= 'A'
group  by Gender
order by Gender_count desc

-- 7-Which time of the day do customers give most ratings?
select time_of_day , AVG(rating) as avg_rating
from Sales
group by time_of_day
order by avg_rating desc

-- 8-Which time of the day do customers give most ratings per branch?
select time_of_day , AVG(rating) as avg_rating
from Sales
where Branch= 'A'
group by time_of_day
order by avg_rating desc

-- 9-Which day of the week has the best avg ratings?
select day_name , AVG(rating) as avg_rating
from Sales
group by day_name
order by avg_rating desc

-- 10-Which day of the week has the best average ratings per branch?
select day_name , AVG(rating) as avg_rating
from Sales
where Branch= 'A'
group by day_name
order by avg_rating desc
