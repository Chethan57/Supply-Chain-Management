#KPI_1  STORE WISE SALES
select `Store name`, sum(`Sales Quantity`) as 'Total Sales'
from point_of_sale p inner join sales sa
on p.`Order number`=sa.`Order number`
inner join store st 
on sa.`Store key`=st.`Store key`
group by `Store name`
order by sum(`Sales Quantity`) desc;

#KPI_2 SALES GROWTH
 With S1 as (select `Fiscal Year`,sum(`Sales amount`) as `Total Sales`,
 lag(sum(`Sales amount`),1,0)  over ( order by `Fiscal Year`) as `Lagged Total sales`
from calendar c inner join sales sa
on c.Date=sa.Date
inner join point_of_sale p 
on sa.`Order number`=p.`Order number`
group by `Fiscal Year`)
select `Fiscal Year`, `Total Sales`,(`Total Sales`-`Lagged Total sales`)/`Lagged Total sales` as `Sales Growth` ,
round(((`Total Sales`-`Lagged Total sales`)/Nullif(`Lagged Total sales`,0) *100),2) as `Sales Growth Percentage`
from S1
order by `Fiscal Year`;

#KPI_3 DAILY SALES TREND(M)
select year(date) as `Year`,month(date) as `Month`,round(sum(`Sales amount`),2) as `Total Sales`
from sales sa inner join point_of_sale p
on sa.`Order number`=p.`Order number`
group by `Year` ,`Month`
order by `Year` ,`Month`;

#KPI_4 BRAND WISE SALES 
select `Product Group`,sum(`Sales Quantity`) as `Total sales`
from product pr inner join point_of_sale p 
on pr.`Product Key`=p.`Product key`
group by `Product Group`;

#KPI_5 GROSS PROFIT
select round(sum(`Sales Amount`)- sum(`Cost Amount`),2) as `Gross Profit`
from point_of_sale;

#KPI_6 PRODUCT IN INVENTORY
select `Product Group`, `Product Name`, sum(`Quantity on Hand`) as `Quantity`
from inventory_adjusted
group by `Product Group`,`Product Name` with rollup
order by `Product Group`;

#KPI_7 OVER STOCK, OUT OF STOCK, UNDER STOCK
select 
count(case when `Quantity on Hand` = 0 then 1 end) `Out of stock`,
count(case when `Quantity on Hand` <= `Sales Quantity` then 2 end) `Under stock`,
count(case when `Quantity on Hand` > `Sales Quantity` then 3 end) `Over stock`
from `point_of_sale` p inner join `inventory_adjusted` i
on p.`Product key`=i.`Product Key`;

#KPI_8 INVENTORY VALUE
select round(sum(Price* `Quantity on Hand`),2) as `Inventory Value`
from `inventory_adjusted`;

#KPI_9 REGION WISE SALES
select `Store Region`,sum(`Sales amount`) as `Total Sales`
from point_of_sale p inner join sales sa
on p.`Order number`=sa.`Order number`
inner join store st 
on sa.`Store key`=st.`Store key`
group by `Store Region`;
                        
#KPI_10 UNIQUE ORDERS BY REGION
select `Store Region`,count(distinct(`Order Number`)) as `Unique Orders`
from sales sa inner join store st
on sa.`Store key`=st.`Store key`
group by `Store Region`;

#KPI_11 TOTAL PROFITS BY REGION
select `Store Region`,round(sum(`Sales Amount`)- sum(`Cost Amount`),2) as ` Profit`
from point_of_sale p inner join sales sa
on p.`Order number`=sa.`Order number`
inner join store st 
on sa.`Store key`=st.`Store key`
group by `Store Region`;

call `Region wise Profit`();
call `Region wise Sales`();











