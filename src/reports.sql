=--The following view is created to use it with a pivot table

--VIEW:

CREATE VIEW crime_report_view AS
    SELECT CRIME_ID, CRIME_NAME, REPORTED_DATE, CLOSED_DATE, CRIME_STATUS, CRIME_TYPE, OFFICER_NOTE,
    HOUSE_NO, STREET_NAME, POST_CODE, CITY_NAME, REGION_NAME,
    FIRST_NAME, MIDDLE_NAME, LAST_NAME, DOB, GENDER, DEPARTMENT,RANK
    FROM CRIME_REGISTER, LOCATION, REGION, OFFICER
    where CRIME_REGISTER.LOCATION_ID = LOCATION.LOCATION_ID and
          CRIME_REGISTER.POLICE_ID = OFFICER.OFFICER_ID and
          LOCATION.REGION_ID = REGION.REGION_ID;

--Report1:
--	Total number of open and closed crimes per city using a pivot, a count function, order by 
SELECT * from (
    SELECT CITY_NAME, CRIME_STATUS 
    FROM 
  crime_report_view 
 )
pivot
(
    Count (CRIME_STATUS)
    for CRIME_STATUS in ('OPEN' as "Open",'CLOSED' as "Closed")
)
order by CITY_NAME;

----------------------------------------------------

--Report2:
--Number of crimes per financial year between the years 2001 to 2021 using sub query, Extract function, Between, group by and order by.

SELECT YEAR AS FINANCIAL_YEAR, COUNT(*) AS NUMBER_OF_CRIMES 
   FROM 
       (
           select EXTRACT(YEAR FROM reported_date) YEAR, CRIME_ID ,LOCATION_ID, POLICE_ID, REPORTED_DATE, CRIME_STATUS
           FROM
           crime_register
       )
 WHERE YEAR BETWEEN 2001 AND 2021 GROUP BY YEAR ORDER BY YEAR ASC;


----------------------------------------------------

-- Report3:
-- Number of crimes per region using subqueries, table joins, count, group by order by

SELECT region_name, crime_numbers_per_region 
FROM
(
SELECT COUNT(*) as crime_numbers_per_region,       region_name
 From 
               (
SELECT cr.crime_id, l.location_id,r.region_id, region_name 
FROM 
crime_register cr, location l, Region r where   cr.location_id = l.location_id and l.region_id = r.region_id
                         )
GROUP BY region_name
) ORDER BY region_name;


--------------------------------------------------------

-- Report4:
-- Region where number of crime is maximum using MAX, count, table joins  and subqueries

SELECT region_name as region_with_max_crimes, CRIME_NUMBERS_PER_REGION as number_of_crimes FROM (SELECT region_name, crime_numbers_per_region FROM
(SELECT count(*) as crime_numbers_per_region, region_name
From 
        (SELECT cr.crime_id, l.location_id,r.region_id, region_name from crime_register cr, location l, Region r where cr.location_id = l.location_id and l.region_id = r.region_id)
GROUP BY region_name) order by region_name)
WHERE 
CRIME_NUMBERS_PER_REGION =(SELECT Max(CRIME_NUMBERS_PER_REGION)
 FROM
 (select region_name, crime_numbers_per_region FROM
(select count(*) as crime_numbers_per_region, region_name
From 
        (select cr.crime_id, l.location_id,r.region_id, region_name from crime_register cr, location l, Region r where cr.location_id = l.location_id and l.region_id = r.region_id)
GROUP BY region_name))
)


----------------------------------------------------------

-- Report5:
-- List of cities where crime numbers is more than the average number of crimes using table joins, count(), Having, AVG(), group by.

SELECT  l.city_name  FROM crime_register c, location l WHERE c.location_id = l.location_id
 GROUP BY l.city_name
HAVING COUNT(*) > (SELECT AVG(COUNT(*)) FROM crime_register GROUP BY location_id)

---------------------------------------------------------------

-- Report6:
-- list of crimes that remained unsolved for more than 2 years and the detective who is assigned with the case

SELECT CRIME_ID, CITY_NAME, o.first_name ||''||o.middle_name||' '||o.last_name AS DETECTIVE, FLOOR((SYSDATE-REPORTED_DATE)/365) AS NUM_OF_YEARS FROM CRIME_REGISTER cr, OFFICER o, LOCATION L WHERE cr.detective_id = o.officer_id AND CRIME_STATUS = 'open' AND DEPARTMENT = 'Investigation' AND FLOOR((SYSDATE-REPORTED_DATE)/365) >2 AND L.location_id = cr.location_id;
