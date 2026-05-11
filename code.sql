select * from Swiggy_Data;

-- Data Validation & CLeaning
-- Null Check
Select
	sum(case when state is null then 1 else 0 end) as null_state,
	sum(case when city is null then 1 else 0 end) as null_city,
	sum(case when order_date is null then 1 else 0 end) as null_order_date,
	sum(case when restaurant_name is null then 1 else 0 end) as null_restaurant,
	sum(case when location is null then 1 else 0 end) as null_location,
	sum(case when category is null then 1 else 0 end) as null_category,
	sum(case when Dish_name is null then 1 else 0 end) as null_dish,
	sum(case when price_INR is null then 1 else 0 end) as null_price,
	sum(case when Rating is null then 1 else 0 end) as null_rating,
	sum(case when rating_count is null then 1 else 0 end) as null_rating_count
from swiggy_data;

-- Blank or Empty Strings
select * 
from Swiggy_Data
where
state = '' OR city = '' OR Restaurant_Name = '' OR location = '' or category = '' or dish_name = '';


-- Duplicate Detection
select
state, city, order_date, restaurant_name, location, category, dish_name, price_INR, rating, rating_count,count(*) as CNT
from Swiggy_Data
group by
state, city, order_date, restaurant_name, location, category, dish_name, price_INR, rating, rating_count
having count(*)>1;

--Delete Duplication
with cte as(
select *, Row_number() over(
	partition by state, city, order_date, restaurant_name, location, category,
	dish_name, price_INR, rating, rating_count
	order by (select null)
	) as rn
	from swiggy_data)
	delete from cte where rn>1;


--Creation Schema
--Dimension Tables
--Date Table
create table dim_date(
	Date_id INT IDENTITY(1,1) Primary key,  --auto-increment
	Full_date date,
	Year int,
	Month int,
	Month_Name varchar(20),
	Quarter int,
	Day int,
	Week int
	)
select * from dim_date;

--dim location
create table dim_location(
	location_id int identity(1,1) primary key,
	State varchar(100),
	City varchar(100),
	Location varchar(200)
);
select * from dim_location;

--dim_restaurant
create table dim_restaurant(
	restaurant_id int identity(1,1) primary key,
	Restaurant_Name varchar(200)
);
select * from dim_restaurant;

--dim_category
create table dim_category(
	category_id int identity(1,1) primary key,
	Category varchar(200)
);
select * from dim_category;

ALTER TABLE dim_dish
ALTER COLUMN Dish_Name Varchar(200);


--dim_dish
create table dim_dish(
	dish_id int identity(1,1) primary key,
	Dish_Name varchar(300)
);
select * from dim_dish;

select * from Swiggy_Data;

--Fact table
create table fact_swiggy_orders (
	order_id int identity(1,1) primary key,

	date_id int,
	Price_INR decimal(10,2),
	Rating Decimal(4,2),
	Rating_count int,

	location_id int,
	restaurant_id int,
	category_id int,
	dish_id int,

	foreign key (date_id) references dim_date(date_id),
	foreign key (location_id) references dim_location(location_id),
	foreign key (restaurant_id) references dim_restaurant(restaurant_id),
	foreign key (category_id) references dim_category(category_id),
	foreign key (dish_id) references dim_dish(dish_id)
);
select * from fact_swiggy_orders;

--Insert data in Tables
--dim_date
insert into dim_date (Full_Date,Year, Month, Month_Name, Quarter, Day, Week)
select distinct
	Order_Date,
	Year(Order_Date),
	Month(Order_date),
	Datename(Month, Order_Date),
	Datepart(Quarter, order_Date),
	Day(Order_Date),
	DatePart(week, Order_Date)
from swiggy_data
where order_date is not null;

select * from dim_date;

-- dim_location
insert into dim_location (State, city, location)
select distinct
	state,
	city,
	location
from swiggy_data;

select * from dim_location;

--dim_restaurant
insert into dim_restaurant (Restaurant_Name)
select distinct
	Restaurant_Name
from swiggy_data;

select * from dim_restaurant;

--dim_category
insert into dim_category (Category)
select distinct
	Category
from swiggy_data;

select * from dim_category;

--dim_dish
insert into dim_dish (Dish_Name)
select distinct
	Dish_Name
from swiggy_data;

select * from dim_dish;

-- fact table
insert into fact_swiggy_orders
(
	date_id,
	Price_INR,
	Rating,
	Rating_Count,
	location_id,
	restaurant_id,
	category_id,
	dish_id
	)
select
	dd.date_id,
	s.price_INR,
	s.Rating,
	s.Rating_Count,

	dl.location_id,
	dr.restaurant_id,
	dc.category_id,
	dsh.dish_id
from swiggy_data s

join dim_date dd
	on dd.Full_Date = s.Order_Date

join dim_location dl
	on dl.State = s.State
	and dl.City = s.city
	and dl.location = s.location

join dim_restaurant dr
	on dr.Restaurant_Name = s.Restaurant_Name

join dim_category dc
	on dc.category = s.category

join dim_dish dsh
	on dsh.Dish_Name = s.Dish_Name;

select * from fact_swiggy_orders;

select * from fact_swiggy_orders f
join dim_date d on f.date_id = d.Date_id
join dim_location l on f.location_id = l.location_id
join dim_restaurant r on f.restaurant_id = r.restaurant_id
join  dim_category c on f.category_id=c.category_id
join dim_dish di on f.dish_id = di.dish_id;

--KPI's
--Total Orders
select count(*) as Total_Orders
from fact_swiggy_orders;

--Total Revenue (INR Million)
select format(sum(convert(float,price_INR))/1000000, 'N2') + 'INR Million'
as Total_Revenue 
from fact_swiggy_orders

--Average Dish Price
select format(avg(convert(float,price_INR)), 'N2') + 'INR'
as Total_Revenue 
from fact_swiggy_orders

--Average Rating
select
avg(Rating) as avg_rating
from fact_swiggy_orders

--Granular requirements or Deep-Dive Business Anlaysis

--Monthly Order Trends
select 
d.year,
d.month,
d.month_name,
sum(price_INR) as Total_Revenue,
count(*) as Total_Orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year,
d.month,
d.month_name
order by sum(price_INR) desc;

--Quarterly Trends
select 
d.year,
d.Quarter,
count(*) as Total_Orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year,
d.Quarter
order by count(*) desc;

--Yearly Trend
select 
d.year,
count(*) as Total_Orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year
order by count(*) desc;

--Orders by Day of week(Mon-sun)
select 
	datename(weekday, d.full_date) as day_name,
	count(*) as total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by datename(weekday, d.full_date),datepart(weekday, d.full_date)
order by datepart(weekday, d.full_date);

--Top 10 cities by order volume
select top 10
l.city,
count(*) as total_orders from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.city
order by count(*) desc

select top 10
l.city,
sum(f.price_INR) as total_revenue from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.city
order by sum(f.price_INR) desc

--Revenue contribution by states
select
l.state,
sum(f.price_INR) as Total_revenue from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.state
order by sum(f.price_INR) desc

--Top 10 restaurants by orders
select top 10
r.restaurant_name,
sum(f.price_INR) as Total_revenue from fact_swiggy_orders f
join dim_restaurant r
on r.restaurant_id = f.restaurant_id
group by r.Restaurant_name
order by sum(f.price_INR) desc;

--Top categories by order volume
select
	c.category,
	count(*) as total_orders
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by c.category
order by total_orders desc;

--Most Ordered Dishes
select top 10
	d.dish_name,
	count(*) as order_count
from fact_swiggy_orders f
join dim_dish d on f.dish_id = d.dish_id
group by d.dish_name
order by order_count desc;

--Cuisine Performance (orders + Avg Rating)
select
	c.category,
	count(*) as total_orders,
	avg(convert(float, f.rating)) as avg_rating
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by c.category
order by total_orders desc;

--Total orders by Price Range
select
	case
		when convert(float, price_inr) < 100 then 'Under 100'
		when convert(float, price_inr) between 100 and 199 then '100 - 199'
		when convert(float, price_inr) between 200 and 299 then '200 - 299'
		when convert(float, price_inr) between 300 and 499 then '300 - 499'
		else '500+'
	end as price_range,
	count(*) as total_orders
from fact_swiggy_orders
group by 
	case
		when convert(float, price_inr) < 100 then 'Under 100'
		when convert(float, price_inr) between 100 and 199 then '100 - 199'
		when convert(float, price_inr) between 200 and 299 then '200 - 299'
		when convert(float, price_inr) between 300 and 499 then '300 - 499'
		else '500+'
	end
order by total_orders desc;

--Rating Count Distribution(1-5)
select
	rating,
	count(*) as rating_count
from fact_swiggy_orders
group by rating
order by count(*) desc;
