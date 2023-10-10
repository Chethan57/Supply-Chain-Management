#KPI 1
SELECT 
sum(sales_amount) as YTD
from f_sales fs inner join f_point_of_sale fp
on fs.order_number=fp.order_number
where year (date)= year(curdate());

#KPI 2
select  `store name`,
sum(sales_amount) as Total_Sales
from d_store ds inner join  f_sales fs
on ds.store_key=fs.store_key
inner join f_point_of_sale fp
on fs.order_number=fp.order_number
group by `store name`;

#KPI 3
select 
year(fs.date) as Year,
sum(sales_amount) as Total_Sales,
lag(sum(sales_amount)) over (order by year(fs.date)) as L1,
(sum(sales_amount) - lag(sum(sales_amount)) over (order by year(fs.date))) / lag(sum(sales_amount))  over(order by year(fs.date)) as Sales_growth,
concat((sum(sales_amount) - lag(sum(sales_amount)) over (order by year(fs.date))) / lag(sum(sales_amount))  over(order by year(fs.date)) *100 ,'%')as Sales_growth_percent
from f_sales fs inner join calendar c
on fs.date=c.date
inner join f_point_of_sale fp
on fs.order_number=fp.order_number
group by Year
order by Year asc;

#KPI 4
select fs.date as Date,
sum(sales_amount) as Daywise_sales,
lag(sum(sales_amount)) over (order by fs.date) as Previous_day_sales,
sum(sales_amount) -lag(sum(sales_amount)) over (order by fs.date) as Daily_sales_trend
from f_sales fs inner join calendar c
on fs.date=c.date
inner join f_point_of_sale fp
on fs.order_number=fp.order_number
group by Date
order by Date desc;

        
#KPI 5
select `Product Group`,
sum(sales_quantity) as Total_Sales
from d_product dp inner join f_point_of_sale fp
on dp.product_key=fp.product_key
group by `Product Group`
order by `Product Group` asc;

#KPI 6
select 
sum(sales_amount- cost_amount) as Gross_profit
from f_point_of_sale ;

#KPI 7
select `Product Group`,
sum(`Quantity on Hand`) as `Product in Inventory`
from f_inventory_adjusted
group by `Product Group` with rollup;

#KPI 8
select 
count(case when `Quantity on Hand` = 0 then 1 end) `Out of stock`,
count(case when `Quantity on Hand` < sales_quantity then 2 end) `Under stock`,
count(case when `Quantity on Hand` > sales_quantity then 3 end) `Over stock`
from f_point_of_sale fs inner join f_inventory_adjusted fa
on fs.product_key=fa.product_key;

#KPI 9
select 
sum(Price*`Quantity on Hand`) as Inventory_Value
from f_inventory_adjusted;

#KPI 10
select `Store Region`,
sum(sales_quantity) as Sales
from d_store ds inner join f_sales fs
on ds.store_key = fs.store_key
inner join f_point_of_sale fp
on fs.order_number=fp.order_number
group by `Store Region` with rollup;

#KPI 11
select `Store region`,
round(sum((sales_amount- cost_amount)-(`Monthly Rent Cost`*timestampdiff(month,`Store Open Date`,now())))) as Total_Profit
from  f_sales fs inner join `d_store2` dss
on fs.store_key=dss.store_key
inner join f_point_of_sale fp
on fp.order_number=fs.order_number
group by `Store region`; 

select  `Store Region`, count(distinct(order_number)) as Unique_Orders
from d_store ds inner join f_sales fs
on ds.store_key=fs.store_key
group by `Store Region`;

#KPI 12
select `Store region`,
round(sum((sales_amount- cost_amount)-(`Monthly Rent Cost`*timestampdiff(month,`Store Open Date`,now())))) as Total_Profit
from  f_sales fs inner join `d_store2` dss
on fs.store_key=dss.store_key
inner join f_point_of_sale fp
on fp.order_number=fs.order_number
group by `Store region`; 