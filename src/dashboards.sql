-- Chart 1: Line graph
-- Number of crimes per financial year
SELECT YEAR AS FINANCIAL_YEAR, COUNT(*) AS NUMBER_OF_CRIMES 
   FROM 
       (
           select EXTRACT(YEAR FROM reported_date) YEAR, CRIME_ID ,LOCATION_ID, POLICE_ID, REPORTED_DATE, CRIME_STATUS
           FROM
           crime_register
       )
 WHERE YEAR BETWEEN 2001 AND 2021 GROUP BY YEAR ORDER BY YEAR ASC;



-- Chart 2: Area graph
-- Total number of crimes per city
select city_name, count(crime_id) as number_of_crimes 
from 
(select crime_id, REPORTED_DATE, CRIME_STATUS, CLOSED_DATE, CITY_NAME, REGION_NAME from crime_register cr, location l, region r where cr.location_id = l.location_id and l.region_id = r.region_id)
 group by city_name;


-- chart3: Donut chart
-- Total number of crimes per region
select count(*) as number_of_crimes ,region_name
from 
(select crime_id, REPORTED_DATE, CRIME_STATUS, CLOSED_DATE, CITY_NAME, REGION_NAME from crime_register cr, location l, region r where cr.location_id = l.location_id and l.region_id = r.region_id)
group by
region_name


-- chart4:  Bar charts
-- List of open and closed crimes
SELECT * from (
    SELECT REGION_NAME, CRIME_STATUS 
    FROM 
  crime_report_view 
 )
pivot
(
    Count (CRIME_STATUS)
    for CRIME_STATUS in ('open' as "Open",'closed' as "Closed")
)
order by REGION_NAME;
