use sales_db;
-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		  ( transactions_id	INT PRIMARY KEY,
            sale_date	DATE,
            sale_time	TIME,
            customer_id	INT,
            gender VARCHAR(15),
            age	INT,
            category	VARCHAR(15),
            quantiy	INT,
            price_per_unit	FLOAT,
            cogs	FLOAT,
            total_sale FLOAT
          );

-- Check whether the data is properly imported or not          
select * from retail_sales;

-- To check the count
select count(*) from retail_sales;

-- Data cleaning 
-- To change column name
alter table retail_sales 
rename column quantiy TO quantity;

-- To check whetehr there are any null values
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or total_sale is null;

-- Data Exporation
-- How many sales we have
select count(*) as total_sales from retail_sales;

-- How many unique customers have
select count(DISTINCT customer_id) as total_cust from retail_sales;

-- How many categories we have
select count(DISTINCT category) as total_cate from retail_sales;

-- Data Analysis
-- write a sql query to retrive all columns for sales made on 2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

-- write a sql query to retrieve all transactioins where the category is clothing as quantity sold is more than 4 in the month nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- write a sql query to claculte total sales for each category
select category, sum(total_sale) as Total_sales from retail_sales
group by category;


-- write a sql query to claculte total sales and orders for each category 
select category, sum(total_sale) as Total_sales,count(*) as total_orders from retail_sales
group by category;

-- write a sql query to find the average age of customers who ordered from the beauty category
select round(avg(age),2) as avg_age from retail_sales
where category='Beauty';

-- write a sql query to find out all transaction where total sales is greater than 1000
select * from retail_sales
where total_sale > 1000;

-- write a sql query to find the total number of transaction(transaction_id) made by each gender in each category
select gender,category,count(transactions_id) as total_transactions from retail_sales
group by gender,category;

-- write a sql query to calculate the avg sales for each month. find out the best selling month in each year.

with monthly_sales as (
select YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month,
        avg(total_sale) as avg_sales
        from retail_sales
        group by YEAR(sale_date), MONTH(sale_date)
        ),
ranked_sales AS (
    SELECT 
        year, 
        month, 
        avg_sales, RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS rank_op
    FROM monthly_sales
)
SELECT *
FROM ranked_sales
WHERE rank_op = 1;

-- write a sql query to find out the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- write a sql query to find out the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as cust_id from retail_sales
group by category;

-- write a sql query to create shift and number of orders (example Morning <= 12,Afternoon between 12 & 17, Evening >17)
with hourly_sales as
(
SELECT *,
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
from retail_sales
)
select shift,
count(*) as total_count
from hourly_sales
group by shift;

-- End of the project
