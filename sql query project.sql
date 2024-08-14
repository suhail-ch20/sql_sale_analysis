--Database-Creation: The project starts by creating a database named `SQL_Project_sales_analysis`.

CREATE DATABASE SQL_Project_sales_analysis;

--Table Creation: A table named `sales` is created to store the sales data.The table structure includes columns for
--transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, 
--price per unit, cost of goods sold (COGS), and total sale amount.

create table sales
	(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar,
	age	int,
	category varchar,
	quantiy int,
	price_per_unit float,
	cogs	float,
	total_sale float

);


select * from sales

copy sales(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale
)
from'B:\sales.csv'
DELIMITER','
HEADER CSV;

--Data Exploration & Cleaning

--Record Count: Determine the total number of records in the dataset--

select count(*) from sales 

--Customer Count: Find out how many unique customers are in the dataset
select count(distinct customer_id) from sales

--Category Count: Identify all unique product categories in the dataset.

select count(distinct category) from sales 

--Null Value Check: Check for any null values in the dataset and delete records with missing data.

select * from sales
where 
sale_date IS NULL OR sale_time is null or customer_id is null or gender is null or age is null 
or category is null or quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

 --Data Analysis & Findings

--Write a SQL query to retrieve all columns for sales made on '2022-11-05--
select * from sales 
where sale_date = '2022-11-05'

--Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from sales
where
category = 'clothing' 
	And quantiy >= 4
	AND TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category
select category,SUM(total_sale) as net_sale,count(customer_id) from sales
	group by category
order by net_sale  desc; 

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select round(avg(age),2) as Average_age from sales
where 
category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from sales
where 
total_sale > 1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select category,gender,count(transactions_id)as totall from sales
 group by gender,category
order by totall desc;

---End of project--

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select extract(month from sale_date) as monthes,
	extract(year from sale_date) as year,
	avg(total_sale) as total from sales
group by monthes,year
order by total desc
limit 2

--Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) from sales
group by customer_id
	order by sum desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category
select category,count(distinct customer_id) as total_customer from sales
group by category 
order by total_customer desc

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift



