SELECT * FROM covid;

-- 1) Write a code to check NULL values?
select * from covid
where Province is null
or 'Country/Region' is null
or Latitude is null
or Longitude is null
or Date is null
or Confirmed is null
or Deaths is null
or Recovered is null;

-- 2) If NULL values are present, update them with zeros for all columns.
-- no NULL

 -- Q3. check total number of rows
select count(*) as total_rows from covid;

-- Q4. Check what is start_date and end_date
select min(Date) as start_date, max(Date) as end_date from covid;

-- Q5. Number of month present in dataset
select timestampdiff(month, '2020-01-22', '2021-06-13') as num_of_months;


-- Q6. Find monthly average for confirmed, deaths, recovered

select 
extract(month from str_to_date(Date,'%Y-%m-%d')) as Month
,extract(year from str_to_date(Date, '%Y-%m-%d')) as Year
,round(avg(Confirmed)) as Avg_Confirmed
,round(avg(Deaths)) as Avg_Deaths
,round(avg(Recovered)) as Avg_Recovered
from covid
group by Month, Year;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
select 
extract(month from str_to_date(Date,'%Y-%m-%d')) as Month
,extract(year from str_to_date(Date, '%Y-%m-%d')) as Year
,substring_index(group_concat(Confirmed order by Confirmed desc), ',',1) as Most_frequent_Confirmed
,substring_index(group_concat(Deaths order by Deaths desc), ',',1) as Most_frequent_Deaths
,substring_index(group_concat(Recovered order by Recovered desc), ',',1) as Most_frequent_recovered
from covid
group by Year, Month
order by Year, Month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
select
extract(year from str_to_date(Date, '%Y-%m-%d')) as Year
,min(Confirmed) as Min_Confirmed
,min(Deaths) as Min_Deaths
,min(Recovered) as Min_Recovered
from covid
group by Year
order by Year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
select
extract(year from str_to_date(Date, '%Y-%m-%d')) as Year
,max(Confirmed) as Min_Confirmed
,max(Deaths) as Min_Deaths
,max(Recovered) as Min_Recovered
from covid
group by Year
order by Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
select 
extract(month from str_to_date(Date,'%Y-%m-%d')) as Month
,extract(year from str_to_date(Date, '%Y-%m-%d')) as Year
,sum(Confirmed) as Total_Confirmed
,sum(Deaths) as Total_Deaths
,sum(Recovered) as Total_Recovered
from covid
group by Year, Month
order by Year, Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
-- (Eg.: total confirmed cases, their average, variance & STDEV )
select
sum(Confirmed) as Total_Confirmed
,round(avg(Confirmed)) as Avg_Confirmed
,round(variance(Confirmed)) as Var_Confirmed
,round(stddev(Confirmed)) as stddev_Confirmed
from covid;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select
sum(Deaths) as Total_Deaths
,round(avg(Deaths)) as Avg_Deaths
,round(variance(Deaths)) as Var_Deaths
,round(stddev(Deaths)) as stddev_Deaths
from covid;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
select
sum(Recovered) as Total_Recovered
,round(avg(Recovered)) as Avg_Recovered
,round(variance(Recovered)) as Var_Recovered
,round(stddev(Recovered)) as stddev_Recovered
from covid;

-- Q14. Find Country having highest number of the Confirmed case
select
'Country/Region',
sum(Confirmed) as Total_Confirmed_Cases
from covid
group by 'Country/Region'
order by Total_Confirmed_Cases desc
limit 1;

-- Q15. Find Country having lowest number of the death case
with rankingCountry as (
select 
'Country/Region'
,sum(Deaths) as Total_Death_Cases
,rank() over(order by sum(Deaths) asc) as rank_no
from covid
group by 'Country/Region'
)
select 'Country/Region'
,Total_Death_Cases
from rankingCountry
where rank_no = 1;

-- Q16. Find top 5 countries having highest recovered case
select 'Country/Region'
,sum(Recovered) as Total_Recovered_Cases
from covid
group by 'Country/Region'
order by Total_Recovered_Cases desc	
limit 5;
