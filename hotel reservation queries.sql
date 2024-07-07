

create table HotelReservation(
Booking_ID varchar(255) ,
no_of_adults int ,
no_of_childern int ,
no_of_weekend_nights int,
no_of_week_nights int,
type_of_meal_plan varchar(255),
room_type_reserved varchar(255),
lead_time int,
arrival_date date ,
market_segment_type varchar(255),
avg_price_per_room float,
booking_status varchar(255));


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Hotel Reservation.csv'
INTO TABLE HotelReservation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



-- exploring data
SELECT 
    *
FROM
    hotelreservation;


-- 1. What is the total number of reservations in the dataset?
SELECT 
    COUNT(Booking_ID) AS total_number_of_reservation
FROM
    hotelreservation; 
-- total number of reservation =700    

-- 2. Which meal plan is the most popular among guests?

SELECT 
    type_of_meal_plan, COUNT(type_of_meal_plan)
FROM
    hotelreservation
WHERE
    type_of_meal_plan IN (SELECT 'Meal Plan 1' AS type_of_meal_plan UNION ALL SELECT 'Meal Plan 2' UNION ALL SELECT 'Not Selected')
GROUP BY type_of_meal_plan;  
-- It seems that Meal plan 1 is the most popular between guests 

--  3. What is the average price per room for reservations involving children?
SELECT AVG(aa) AS avg_price_per_room_with_childerns
FROM (
    SELECT avg_price_per_room AS aa
    FROM hotelreservation
    WHERE no_of_childern != 0
) AS derived_table_alias;

-- The average price per room for reservations involving children =144.57$  

-- 4. How many reservations were made for the year 2018? 
SELECT 
    COUNT(Booking_ID) AS num_of_2018_reservations
FROM
    hotelreservation
WHERE
    arrival_date BETWEEN '2018-01-01' AND '2018-12-31'; 
-- Number of reservations were made for the year 2018 =577  

-- 5. What is the most commonly booked room type? 
SELECT DISTINCT
    room_type_reserved
FROM
    hotelreservation;
-- There are three types of rooms Room_Type 1,4,2,6,5,7 
SELECT 
   room_type_reserved, COUNT(room_type_reserved)
FROM
    hotelreservation
WHERE
   room_type_reserved IN (SELECT 'Room_Type 1' AS  room_type_reserved UNION ALL SELECT 'Room_Type 4' UNION ALL SELECT 'Room_Type 2'UNION ALL SELECT 'Room_Type 6' UNION ALL SELECT 'Room_Type 5' UNION ALL SELECT 'Room_Type 7')
GROUP BY  room_type_reserved;  
-- The most commonly booked room type is Room_Type 1 

 -- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)? 
select count(Booking_ID) as no_of_weekend_reservations 
from hotelreservation
where no_of_week_nights>0;  
-- reservations fall on a weekend =656  

-- 7. What is the highest and lowest lead time for reservations? 
SELECT 
    MAX(lead_time) AS highest_lead_time,
    MIN(lead_time) AS lowest_lead_time
FROM
    hotelreservation;
-- The highest lead time for reservation is 443 days and the lowest is 0 days 

-- 8. What is the most common market segment type for reservations?
SELECT 
    market_segment_type, COUNT(market_segment_type) AS count
FROM
    hotelreservation
GROUP BY market_segment_type
ORDER BY count DESC
LIMIT 1;

-- The most common market segment type for reservations is Online  


-- 9. How many reservations have a booking status of "Confirmed"? 
    
select booking_status,count(booking_status)
from hotelreservation
group by booking_status; 
-- Reservations that have booking status ofconfirmed =493,but reservations that were canceled=207 


-- 10. What is the total number of adults and children across all reservations? 
SELECT 
    (a + c) AS total_no_of_adults_childern
FROM
    (SELECT 
        SUM(no_of_adults) AS a, SUM(no_of_childern) AS c
    FROM
        hotelreservation) AS x;
-- the total number of adults and children across all reservations =1385 

-- 11. What is the average number of weekend nights for reservations involving children?
SELECT 
    AVG(no_of_weekend_nights) AS avg_no_of_weekend_nights
FROM
    hotelreservation
WHERE
    no_of_childern > 0; 
-- The average number of weekend nights for reservations involving children =1 

-- 12. How many reservations were made in each month of the year?  

SELECT 
    EXTRACT(MONTH FROM arrival_date) AS month, COUNT(*) as no_reservations
FROM
    hotelreservation
GROUP BY month 
order by no_reservations desc;   
    
    
-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?

SELECT 
    room_type_reserved,
    (AVG(no_of_weekend_nights + no_of_week_nights)) AS avg_no_of_nights
FROM
    hotelreservation
GROUP BY room_type_reserved
ORDER BY avg_no_of_nights DESC;

-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type?
SELECT 
    room_type_reserved, AVG(avg_price_per_room) avg_room_price
FROM
    hotelreservation
WHERE
    no_of_childern > 0
GROUP BY room_type_reserved
ORDER BY avg_room_price DESC
LIMIT 1; 
-- the most common room type for reservations involves childerns is Room_Type 7 and the average price for it =187.04$  


-- 15. What is the market segment type that generates the highest average price per room?
SELECT 
    market_segment_type, AVG(avg_price_per_room) avg_room_price
FROM
    hotelreservation
GROUP BY market_segment_type
ORDER BY avg_room_price DESC
LIMIT 1; 

-- the market segment type that generates the highest average price per room is Online with average room price =112.46$ 





