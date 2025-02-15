# sql_retail_sales
## **Objective**  
The SQL script is designed to **create, explore, clean, and analyze** a **retail sales dataset**. It performs the following tasks:
1. **Table Creation** – Defines the schema for the `retail_sales` table.  
2. **Data Validation & Cleaning** – Checks for missing values and removes incomplete records.  
3. **Data Exploration** – Counts records, unique customers, and categories.  
4. **Business Analysis** – Extracts sales insights, customer behaviors, and key performance metrics.  

---

## **Step-by-Step Breakdown**  

### **1. Table Creation**  

```sql
drop table if exists retail_sales;
```
- Ensures the table **does not already exist** before creating a new one.  

```sql
create table retail_sales (
    transactions_id int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(50),
    age int,
    category varchar(15),
    quantity int,
    price_per_unit float,
    cogs float,
    total_sale float
);
```
- Creates the `retail_sales` table with key fields.  

---

### **2. Viewing Initial Data**  

```sql
select * from retail_sales;
select * from retail_sales limit 10;
```
- Fetches all records and **first 10 records** for a quick preview.  

---

### **3. Data Cleaning & Missing Value Handling**  

```sql
select count(*) from retail_sales;
```
- Counts total number of records.  

```sql
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
```
- Identifies records with **missing values**.  

```sql
delete from retail_sales
where quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
```
- Removes **incomplete records**.  

---

### **4. Data Exploration**  

```sql
select count(*) from retail_sales;
```
- Re-checks **total records** after cleaning.  

```sql
select count(distinct(customer_id)) as total_customers from retail_sales;
```
- Counts **unique customers**.  

```sql
select distinct(category) as categories from retail_sales;
```
- Lists **all product categories**.  

---

### **5. Business Analysis**  

#### **a) Sales Data for a Specific Date**  
```sql
select * from retail_sales where sale_date = '2022-11-05';
```
- Retrieves all **transactions** on **November 5, 2022**.  

#### **b) Sales of Clothing in November 2022 (Quantity > 4)**  
```sql
select * from retail_sales
where category = 'Clothing'
    and to_char(sale_date,'YYYY-MM') = '2022-11'
    and quantity >= 4;
```
- Fetches all **clothing sales** where **quantity is greater than 4** in **November 2022**.  

#### **c) Total Sales per Category**  
```sql
select category, sum(total_sale) as total_sale
from retail_sales
group by category
order by total_sale desc;
```
- Calculates **total revenue per category**, sorted in descending order.  

#### **d) Average Age of Customers in the Beauty Category**  
```sql
select category, round(avg(age),0)
from retail_sales
where category = 'Beauty'
group by category;
```
- Computes the **average age** of customers purchasing **Beauty** products.  

#### **e) High-Value Transactions (Sales > 1000)**  
```sql
select * from retail_sales where total_sale > 1000;
```
- Identifies **high-value transactions**.  

#### **f) Transactions Count by Gender & Category**  
```sql
select category, gender, count(transactions_id)
from retail_sales
group by category, gender
order by category, gender;
```
- Counts **transactions per gender and category**.  

#### **g) Finding the Best Sales Month per Year**  
```sql
select years, months from (
    select extract(month from sale_date) as months,
           extract(year from sale_date) as years,
           avg(total_sale) as avg_sale,
           rank() over (partition by extract(year from sale_date)
                        order by avg(total_sale) desc) as ranked
    from retail_sales
    group by extract(month from sale_date), extract(year from sale_date)
    order by extract(year from sale_date), avg_sale desc
) dup
where ranked = 1;
```
- Identifies **the month with the highest average sales for each year**.  

#### **h) Top 5 Customers by Total Sales**  
```sql
select customer_id, sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc, customer_id asc
limit 5;
```
- Finds **top 5 customers** with the highest **total sales**.  

#### **i) Unique Customer Count Per Category**  
```sql
select category, count(distinct(customer_id))
from retail_sales
group by category;
```
- Determines **how many unique customers** purchased items from each **category**.  

#### **j) Grouping Sales into Time-Based Shifts**  
```sql
with hourly_sale as (
    select *,
           case
               when extract(hour from sale_time) < 12 then 'Morning'
               when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
               else 'Evening'
           end as shift
    from retail_sales
)
select shift, count(*)
from hourly_sale
group by shift;
```
- Categorizes **sales into shifts** (`Morning`, `Afternoon`, `Evening`).  

---

## **Conclusion**  
This script provides a **comprehensive data pipeline** for retail sales analysis.
✅ **Data Cleaning** – Ensures accuracy by removing incomplete records.  
✅ **Exploratory Analysis** – Gives insights into customers, products, and transactions.  
✅ **Business Insights** – Identifies top-selling categories, customer behaviors, and revenue trends.  

Would you like any modifications or further breakdowns? 😊

