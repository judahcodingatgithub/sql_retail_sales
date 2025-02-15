drop table if exists retail_sales;
create table retail_sales (transactions_id	int primary key,
                           sale_date date, 
	                       sale_time time,
	                       customer_id	int,
	                       gender	varchar(50),
	                       age	int,
	                       category varchar(15),
	                       quantity int,
	                       price_per_unit	float,
	                       cogs	float,
	                       total_sale float
	                      );
select * from retail_sales;
select * from retail_sales
limit 10;
select count(*) from retail_sales;
select * from retail_sales 
where transactions_id is null 
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
delete from retail_sales
where quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
-- data exploration
-- how many records do we have?
select count(*) from retail_sales;
-- how many customers do we have?
select count(distinct(customer_id)) as total_customers from retail_sales;
--how many categories do we have?
select distinct(category) as categories from retail_sales;
--data analysis and buissness key problems
-- write a query to retrieve data for sales for the date '2022-11-05'?
select * from retail_sales
where  sale_date = '2022-11-05';
-- write a sql query to retrieve all transaction where the category is 'clothing' and where the
-- quantity sold is more than 4 in the month of 'nov-2022'
select * from retail_sales
where category = 'Clothing' and to_char(sale_date,'YYYY-MM')='2022-11'
	and quantity>=4;
-- write a sql query to calculate total sales for each category
select category,sum(total_sale) as total_sale from retail_sales
group by category
order by sum(total_sale) desc ;
-- what is the average age of customers who purchased items from the beauty category
select category,round(avg(age),0) from retail_sales
where category = 'Beauty' 
group by category;
-- write a query to find all transactions where the total_sale>1000
select * from retail_sales
where  total_sale>1000;
-- the total number of transactions from each gender each category
select category,gender,count(transactions_id) from retail_sales
group by category,gender
order by category,gender;
-- write a query to find avg sale for each month.find the month with highest sale in each year
select years,months from
(select extract(month from sale_date) as months ,extract(year from sale_date) as years
,avg(total_sale) as av,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as ranked
from retail_sales 
group by extract(month from sale_date),extract(year from sale_date)
order by extract(year from sale_date),avg(total_sale) desc) dup
where ranked = 1;
-- write a query to find top 5 customers based on total sales
select customer_id,sum(total_sale) from retail_sales
group by customer_id
order by sum(total_sale) desc,customer_id asc
limit 5;
-- write a query to find the amount of unique customers who purchased items from each category
select category,count(distinct(customer_id)) from retail_sales
group by category;
-- create shifts for a group of time lines. count orders in each shift
with hourly_sale as (select *,case
	when extract(hour from sale_time)<12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	else 'evening'
	end as shift
	from retail_sales)
select shift,count(*) from hourly_sale
group by shift ;






