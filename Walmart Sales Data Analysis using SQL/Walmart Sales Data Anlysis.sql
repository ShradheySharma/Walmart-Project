-- create database
create database if not exists SalesDataWalmart;

-- create table
create table if not exists sales(invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_meathod varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_per float(11,9),
gross_income decimal(12,4),
rating float(2,1));

-- add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
    
    -- add the day_name column
    select date,
    dayname(date) as day_name
    from sales;
    
    alter table sales add column day_name varchar(10);
    
    update sales
    set day_name = dayname(date);
    
 -- add the month_name column
 select date,
 monthname(date) as month_name
from sales;
 
 alter table sales add column month_name varchar(10);
 
update sales
set month_name = monthname(date);

-- EDA = EXPLORATORY DATA ANALYSIS
-- 1. how many unique cities does the data have?
select distinct city from sales;

 -- 2. in which city is each branch?
select distinct branch from sales;

select distinct city, branch from sales;
 
 -- 3. what is the most common payment meathod?
 select payment_meathod, count(payment_meathod) as cnt
 from sales
 group by payment_meathod
 order by cnt desc;
 
 -- 4. what is the most selling product line?
select product_line, count(product_line) as cnt
from sales 
group by product_line
order by cnt desc;

-- 5. what is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- 6. what month had the largest COGS?
select month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc; 

-- 7. what product line had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- 8. what is the city with the largeat revenue?elect product_line,
select branch,city,
sum(total) as total_revenue
from sales
group by branch,city
order by total_revenue desc;

-- 9.  what product line had the largest VAT?
select product_line,
avg(vat) as avg_tax
from sales 
group by product_line
order by avg_tax desc;

-- 10. fetch each product line and add a column to those product line showing 'good','bad'.good if its greater than average sales?
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 11. which branch sold more products than average product sold?
select branch,
sum(quantity)as qty
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- 12. what is the most common product line by gender?
select gender, product_line,
count(gender) as total_cnt
from sales
group by gender,product_line
order by total_cnt desc; 

-- 13. what is the average rating of each product line?
select
round(avg(rating),2) as avg_rating, product_line
from sales
group by product_line
order by avg_rating desc;

-- 14. number of sales made in each time of the day per weekday?
select time_of_day,
count(*) as total_sales
from sales
where day_name='sunday'
group by time_of_day
order by total_sales desc;

-- 15. which of the customer types brings the most revenue?
select customer_type,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;

-- 16. which city has the largest tax percent/ VAT ( value added tax)?
select city,
avg(vat) as vat
from sales
group by city
order by vat desc;

-- 17. which customer type pays the most in vat?
select customer_type,
avg(vat) as vat
from sales
group by customer_type
order by vat desc; 

-- 18. how many unique customer types does the data have?
select
distinct customer_type
from sales;

-- 19. how many unique payment meathods does the data have?
select 
distinct payment_meathod
from sales;

-- 20. what is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- 21. which customer type buys the most?
select customer_type,
count(*) as cnt
from sales
group by customer_type;

-- 22. what is the gender of most of the customers?
select gender,
count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- 23.  what is the gender distribution per branch?
select gender, 
count(*) as gender_cnt
from sales
where branch = 'a'
group by gender
order by gender_cnt desc;

-- 24. which time of the day do customers give more ratings?
 select time_of_day,
 avg(rating) as avg_rating
 from sales
 group by time_of_day
 order by avg_rating desc;
 
 -- 25. which time of the day do customers give most ratings per branch?
 select time_of_day,
 avg(rating) as avg_rating
 from sales
 where branch='b'
 group by time_of_day
 order by avg_rating desc;
 
 -- 26. which day of the week has the best average ratings?
 select day_name,
 avg(rating) as avg_rating
 from sales
 group by day_name
 order by avg_rating desc;
 
 -- 27. which day of week has the best average ratings per branch?
 select day_name,
 avg(rating) as avg_rating
 from sales
 where branch ='c'
 group by day_name
 order by avg_rating desc;
