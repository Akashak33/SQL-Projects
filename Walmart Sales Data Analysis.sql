/*************Prodcut Analysis**********************/

/*Q.1) How many unique cities does the data have?*/
select distinct city from walmartsalesdata;

/*Q.2) In which city is each branch?*/
select distinct City, Branch from walmartsalesdata;

/*Q.3) How many unique product lines does the data have?*/
select Count(distinct Product_line) from walmartsalesdata;

/*Q.4) What is the most common payment method?*/
select payment, count(payment) as Payment_method_total
from walmartsalesdata
group by payment
order by Payment_method_total desc
limit 1;

/*Q.4) What is the most selling product line?*/
select product_line, count(product_line) as product_line_total
from walmartsalesdata
group by product_line
order by product_line_total desc
limit 1;

/*Q.5) What is the total revenue by month?*/
select monthname(date) as month, round(sum(total),2) as Total_Revenue
from walmartsalesdata
group by month
order by Total_Revenue desc;

/*Q.6) What month has the largest cogs?*/
select monthname(date) as month, round(sum(cogs),2) as Total_Cogs
from walmartsalesdata
group by month
order by Total_Cogs desc;

/*Q.6) What product line has the largest revenue?*/
select product_line, sum(total) as total_revenue
from walmartsalesdata
group by product_line
order by total_revenue desc;

/*Q.7) Fetch each product line and add a column to those product line showing 'Good', 'Bad'. Good if its greater than average sales.*/
select product_line, round(sum(total),2) as sales,
case when sum(total) > avg(Total) then 'Good' else 'Bad' end as rating
from walmartsalesdata
group by Product_line;


/*Q.8) Which branch sold more products than the average product sold?*/
select branch, sum(quantity)
from walmartsalesdata
group by branch
having sum(quantity) > (select avg(Quantity) from walmartsalesdata)
order by sum(quantity) desc;

/*Q.9) What is the most common product line by gender?*/
select product_line, gender, count(gender) as gender_count
from walmartsalesdata
group by product_line, gender
order by gender_count desc;

/*Q.10) What is the average rating of each product line?*/
select Product_line, round(avg(rating),2) as avg_rating
from walmartsalesdata
group by Product_line
order by avg_rating desc;

/*****************************SALES ANALYSIS**********************************/
/*Q.1) /*Q.7) Number of sales made in each day of the weekday.*/
Select dayname(date) as day_name, count(total) as no_of_sales
from walmartsalesdata
group by day_name
order by no_of_sales desc;

/*Q.2) Which of the customer types brings the most revenue?*/
select Customer_type, round(sum(total),2) as total_revenue
from walmartsalesdata
group by Customer_type
order by total_revenue desc;

/*Q.3) Which city has the largest tax?*/
select city, round(Avg(Tax),2) as avg_tax
from walmartsalesdata
group by city
order by avg_tax desc;

/************************************CUSTOMER ANALYSIS***********************************/
/*Q.1) How many customer types does the data have?*/
select distinct customer_type
from walmartsalesdata;

/*Q.2) How many unique payment methods does data have?*/
select distinct payment
from walmartsalesdata;

/*Q.3) What is the most common customer type?*/
select customer_type, count(*) as customer_type_count
from walmartsalesdata
group by customer_type;

/*Q.4) What is the gender of most of the customers?*/
select gender, count(*)
from walmartsalesdata
group by gender;

/*Q.5) What is the gender distribution per branch?*/
select gender, branch, count(*) as Gender_Count
from walmartsalesdata
group by gender, branch
order by branch;

/*Q.6) Which day of the week has the best avg ratings?*/
select dayname(date) as day_name, round(avg(rating),2) as avg_rating
from walmartsalesdata
group by day_name
order by avg_rating desc;