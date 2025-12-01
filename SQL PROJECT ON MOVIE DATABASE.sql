-- Start Fresh!
DROP DATABASE IF EXISTS MOVIE_BOOKING;
CREATE DATABASE MOVIE_BOOKING;
USE MOVIE_BOOKING;
SET AUTOCOMMIT=0;
USE MOVIE_BOOKING;

CREATE TABLE MOVIES (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_year INT,
    ticket_price DECIMAL(6,2)
);

INSERT INTO MOVIES VALUES
(1, 'Pathaan', 'Action', 2023, 250.00),
(2, 'Jawan', 'Action', 2023, 300.00),
(3, 'Animal', 'Drama', 2023, 350.00),
(4, 'RRR', 'Action', 2022, 200.00),
(5, 'Brahmastra', 'Fantasy', 2022, 280.00);

CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15)
);

INSERT INTO CUSTOMERS VALUES
(1, 'Raj Sharma', 'raj@email.com', '9876543210'),
(2, 'Priya Patel', 'priya@email.com', '9988776655'),
(3, 'Amit Kumar', 'amit@email.com', '9123456789'),
(4, 'Neha Singh', 'neha@email.com', '9444555666'),
(5, 'Rohit Verma', 'rohit@email.com', '9333222111');

CREATE TABLE SHOWTIMES (
    showtime_id INT PRIMARY KEY,
    movie_id INT,
    show_date DATE,
    show_time TIME,
    theater VARCHAR(50)
);

INSERT INTO SHOWTIMES VALUES
(1, 1, '2024-01-15', '14:00:00', 'PVR Cinemas'),
(2, 1, '2024-01-15', '18:30:00', 'INOX Mall'),
(3, 2, '2024-01-16', '15:00:00', 'Cinepolis'),
(4, 3, '2024-01-17', '20:00:00', 'PVR Cinemas'),
(5, 4, '2024-01-18', '13:00:00', 'INOX Mall');


CREATE TABLE BOOKINGS (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    showtime_id INT,
    seats_booked INT,
    total_amount DECIMAL(8,2),
    booking_date DATE
);

INSERT INTO BOOKINGS VALUES
(1, 1, 1, 2, 500.00, '2024-01-10'),
(2, 2, 2, 3, 750.00, '2024-01-11'),
(3, 1, 3, 1, 300.00, '2024-01-12'),
(4, 3, 4, 2, 700.00, '2024-01-13'),
(5, 4, 5, 4, 800.00, '2024-01-14');

-- See all tables
SHOW TABLES;

-- Check structure
DESC MOVIES;
DESC CUSTOMERS;
DESC SHOWTIMES;
DESC BOOKINGS;


-- See sample data
SELECT * FROM MOVIES;
SELECT * FROM CUSTOMERS LIMIT 3;

SELECT 
    C.name,
    M.title AS MOVIE_KA_NAAM,
    M.ticket_price,
    B.seats_booked
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.customer_id = B.customer_id
JOIN SHOWTIMES S ON B.showtime_id = S.showtime_id
JOIN MOVIES M ON S.movie_id = M.movie_id;

SELECT 
    M.genre,
    COUNT(*) AS Total_Bookings,
    SUM(B.total_amount) AS Revenue
FROM MOVIES M
JOIN SHOWTIMES S ON M.movie_id = S.movie_id
JOIN BOOKINGS B ON S.showtime_id = B.showtime_id
GROUP BY M.genre;

SELECT 
    M.title,
    COUNT(B.booking_id) AS Bookings
FROM MOVIES M
LEFT JOIN SHOWTIMES S ON M.movie_id = S.movie_id
LEFT JOIN BOOKINGS B ON S.showtime_id = B.showtime_id
GROUP BY M.title;

-- Add IMDB rating column
ALTER TABLE MOVIES 
ADD COLUMN imdb_rating DECIMAL(3,1);

-- Check if added
DESC MOVIES;
-- Update with real IMDB ratings
UPDATE MOVIES SET imdb_rating = 7.0 WHERE movie_id = 1;  -- Pathaan
UPDATE MOVIES SET imdb_rating = 8.0 WHERE movie_id = 2;  -- Jawan
UPDATE MOVIES SET imdb_rating = 6.5 WHERE movie_id = 3;  -- Animal
UPDATE MOVIES SET imdb_rating = 8.1 WHERE movie_id = 4;  -- RRR
UPDATE MOVIES SET imdb_rating = 5.5 WHERE movie_id = 5;  -- Brahmastra

-- Verify updates
SELECT * FROM MOVIES;

SELECT 
    title,
    genre,
    imdb_rating,
    ticket_price
FROM MOVIES
WHERE imdb_rating > 5
ORDER BY imdb_rating DESC;

SELECT 
    genre,
    AVG(imdb_rating) AS avg_rating,
    COUNT(*) AS movies_count
FROM MOVIES
GROUP BY genre
ORDER BY avg_rating DESC;

SELECT 
    C.name AS Customer,
    M.title AS Movie,
    M.imdb_rating AS Rating,
    B.seats_booked AS Seats,
    B.total_amount AS Amount
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.customer_id = B.customer_id
JOIN SHOWTIMES S ON B.showtime_id = S.showtime_id
JOIN MOVIES M ON S.movie_id = M.movie_id
WHERE M.imdb_rating > 7.0
ORDER BY M.imdb_rating DESC;
use movie_booking;
-- desc movies;
select * from bookings order by total_amount asc;

select 
title,
imdb_rating,

CASE 
WHEN IMDB_RATING>=8.0 then 'blockbuster'
when IMDB_RATING>=7 then 'good'
when IMDB_RATING>=6 then 'average'
else 'poor'
end as reviews
from movies
order by IMDB_RATING desc;

SELECT 
C.NAME,
S.THEATER,M.TITLE,
B.TOTAL_AMOUNT
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
JOIN SHOWTIMES S ON S.SHOWTIME_ID=B.SHOWTIME_ID
JOIN MOVIES M ON M.MOVIE_ID=S.MOVIE_ID;

SELECT 
    M.title,
    M.imdb_rating,
    COUNT(B.booking_id) AS Total_Bookings,
    SUM(B.total_amount) AS Revenue
FROM MOVIES M
JOIN SHOWTIMES S ON M.movie_id = S.movie_id
JOIN BOOKINGS B ON S.showtime_id = B.showtime_id
WHERE M.imdb_rating > 7.0
GROUP BY M.title, M.imdb_rating
ORDER BY Total_Bookings DESC;

SELECT * FROM CUSTOMERS;

SELECT 
C.NAME,
C.EMAIL,
B.SEATS_BOOKED,
C.PHONE,B.BOOKING_DATE,
B.TOTAL_AMOUNT AS PICTURE_KA_PAISA
FROM CUSTOMERS  C 
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC; 


-- Total spending per customer
SELECT 
    C.NAME,
    C.EMAIL,
    COUNT(B.BOOKING_ID) AS TOTAL_BOOKINGS,
    SUM(B.TOTAL_AMOUNT) AS TOTAL_SPENT,
    AVG(B.TOTAL_AMOUNT) AS AVG_ORDER_VALUE
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME, C.EMAIL
ORDER BY TOTAL_SPENT DESC;

SELECT
C.NAME,
C.EMAIL,
COUNT(B.BOOKING_ID) AS TOTAL_BOOKINGS,
SUM(B.TOTAL_AMOUNT) AS TOTAl_SPENT,
AVG(B.TOTAL_AMOUNT) AS AAMCHI_ORDER_KHARCHA
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
GROUP BY C.NAME,C.EMAIL,C.CUSTOMER_ID
ORDER BY TOTAL_SPENT DESC;

SELECT
C.NAME,
SUM(B.TOTAL_AMOUNT) AS SARA_KARCHA
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
HAVING SUM(B.TOTAL_AMOUNT) > 500
ORDER BY SARA_KARCHA DESC;

SELECT
  C.NAME,
  SUM(B.TOTAL_AMOUNT) AS SARA_KARCHA
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
HAVING SUM(B.TOTAL_AMOUNT) > 500
ORDER BY SARA_KARCHA DESC;

SELECT 
    customer_id,
    total_amount,
    ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS row_num
FROM BOOKINGS;

SELECT 
    customer_id,
    total_amount,
    RANK() OVER (ORDER BY total_amount DESC) AS rank_num
FROM BOOKINGS;

SELECT 
C.NAME,
B.BOOKING_DATE,
M.MOVIE_ID,
M.TITLE AS MOVIE_NAME,
B.TOTAL_AMOUNT AS AISH_KA_KAHRCHA
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
JOIN SHOWTIMES S ON S.SHOWTIME_ID=B.SHOWTIME_ID
JOIN MOVIES M ON M.MOVIE_ID=S.MOVIE_ID
ORDER BY AISH_KA_KAHRCHA DESC limit 5;

SELECT 
C.NAME,
B.TOTAL_AMOUNT AS KHARCHE,
CASE 
WHEN B.TOTAL_AMOUNT >700 THEN 'VIP'
WHEN B.TOTAL_AMOUNT >400 THEN 'AVERAGE_GANDU'
WHEN B.TOTAL_AMOUNT >300 THEN 'NORMAL_TATTA'
ELSE 'PHAKIR'
END AS CUSTOMERS_KI_AUKAT
FROM CUSTOMERS C JOIN BOOKINGS B ON
C.CUSTOMER_ID=B.CUSTOMER_ID
ORDER BY KHARCHE DESC;


SELECT
C.NAME,
B.TOTAL_AMOUNT AS KHARCHE
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
WHERE B.TOTAL_AMOUNT >
(SELECT AVG (TOTAL_AMOUNT) FROM BOOKINGS)
ORDER BY KHARCHE DESC;

-- Customers who spent more than average
SELECT 
    C.NAME,
    B.TOTAL_AMOUNT AS PICTURE_KA_PAISA
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
WHERE B.TOTAL_AMOUNT > (
    SELECT AVG(TOTAL_AMOUNT) FROM BOOKINGS
)
ORDER BY PICTURE_KA_PAISA DESC;


SELECT
C.NAME,
B.TOTAL_AMOUNT AS PICTURE_KA_PAISA
FROM CUSTOMERS C JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
WHERE B.TOTAL_AMOUNT > (SELECT AVG(TOTAL_AMOUNT) FROM BOOKINGS)
ORDER BY PICTURE_KA_PAISA DESC;

SELECT
C.NAME,
B.TOTAL_AMOUNT AS PICTURE_KA_PAISA,
RANK() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS SPENDING_RANK
FROM CUSTOMERS C JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
ORDER BY PICTURE_KA_PAISA DESC;


-- Recent bookings only (last 30 days)
SELECT 
    C.NAME,
    B.TOTAL_AMOUNT AS PICTURE_KA_PAISA,
    B.BOOKING_DATE
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
WHERE B.BOOKING_DATE >= CURDATE() - INTERVAL 30 DAY
ORDER BY PICTURE_KA_PAISA DESC;

-- select
-- c.name,
-- coalesce(b.total_amount, 0) as picture_ka_paisa,
-- case 
-- when b.booking_id is null then 'never booked'
-- else 'booked'
-- end as status
-- from customers c join bookings b on c.customer_id=b.customer_id
-- order by picture_ka_paisa desc;
SELECT
C.NAME,
M.TITLE,
B.SEATS_BOOKED,
B.TOTAL_AMOUNT AS ROKRA
FROM CUSTOMERS C JOIN BOOKINGS B ON 
C.CUSTOMER_ID=B.CUSTOMER_ID
JOIN SHOWTIMES S ON B.SHOWTIME_ID = S.SHOWTIME_ID
JOIN MOVIES M ON S.MOVIE_ID=M.MOVIE_ID
WHERE M.GENRE = 'ACTION'
AND B.TOTAL_AMOUNT > 500
AND B.BOOKING_DATE >= '2024-01-01'
ORDER BY ROKRA DESC;


SELECT
C.NAME,
C.EMAIL,
COUNT(B.BOOKING_ID) AS TOTAL_BOOKS,
SUM(B.TOTAL_AMOUNT) AS TOTAL_SPENT,
AVG(B.TOTAL_AMOUNT) AS AVG_ORDER,
MIN(B.TOTAL_AMOUNT) AS LOWEST_ORDER,
MAX(B.TOTAL_AMOUNT) AS HIGHEST_ORDER,
CASE
WHEN SUM(B.TOTAL_AMOUNT) > 1000 THEN 'PLATINUM'
WHEN SUM(B.TOTAL_AMOUNT) > 500 THEN 'GOLD'
ELSE 'SILVER'
END AS LOYALTY_STATUS
FROM CUSTOMERS C JOIN BOOKINGS B ON 
C.CUSTOMER_ID=B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME, C.EMAIL
ORDER BY TOTAL_SPENT DESC ;


-- Ultimate customer analysis
SELECT 
    C.NAME,
    C.EMAIL,
    COUNT(B.BOOKING_ID) AS TOTAL_BOOKINGS,
    SUM(B.TOTAL_AMOUNT) AS TOTAL_SPENT,
    AVG(B.TOTAL_AMOUNT) AS AVG_ORDER,
    MAX(B.TOTAL_AMOUNT) AS HIGHEST_ORDER,
    MIN(B.TOTAL_AMOUNT) AS LOWEST_ORDER,
    CASE 
        WHEN SUM(B.TOTAL_AMOUNT) > 1000 THEN '💎 PLATINUM'
        WHEN SUM(B.TOTAL_AMOUNT) > 500 THEN '🥇 GOLD'
        ELSE '🥈 SILVER'
    END AS LOYALTY_STATUS
FROM CUSTOMERS C 
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME, C.EMAIL
ORDER BY TOTAL_SPENT DESC;



SELECT 
    customer_id,
    total_amount,
    Lead(total_amount) OVER (ORDER BY total_amount DESC) AS previous_amount
FROM BOOKINGS;

SELECT 
    customer_id,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS customer_rank
FROM BOOKINGS;

-- Create sample bookings with some same amounts
CREATE TABLE BOOKINGS_SAMPLE (
    booking_id INT,
    customer_name VARCHAR(50),
    amount DECIMAL(8,2)
);

INSERT INTO BOOKINGS_SAMPLE VALUES
(1, 'Raj', 900.00),
(2, 'Priya', 800.00),
(3, 'Amit', 800.00),  -- Same as Priya!
(4, 'Neha', 700.00),
(5, 'Rohit', 700.00), -- Same as Neha!
(6, 'Sneha', 500.00);

SELECT 
    customer_name,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num
FROM BOOKINGS_SAMPLE;

SELECT 
    customer_name,
    amount,
    RANK() OVER (ORDER BY amount DESC) AS rank_num
FROM BOOKINGS_SAMPLE;

SELECT 
    customer_name,
    amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank_num
FROM BOOKINGS_SAMPLE;

-- See difference between all three
SELECT 
    C.NAME,
    B.TOTAL_AMOUNT,
    ROW_NUMBER() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS row_num,
    RANK() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS dense_rank_num
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID;
use movie_booking;

SELECT 
    customer_name,
    amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank_num
FROM BOOKINGS_SAMPLE;

-- See difference between all three
SELECT 
    C.NAME,
    B.TOTAL_AMOUNT,
    ROW_NUMBER() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS row_num,
    RANK() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY B.TOTAL_AMOUNT DESC) AS dense_rank_num
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID;

-- Get top 3 spenders
WITH RankedCustomers AS (
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rn
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
SELECT * FROM RankedCustomers WHERE rn <= 3;

SELECT
booking_date,
TOTAL_AMOUNT,
row_number() OVER (ORDER BY TOTAL_AMOUNT DESC) AS DENSE_RANK_NUM
FROM BOOKINGS limit 1;

INSERT INTO CUSTOMERS VALUES
(6, 'Vikram Singh', 'vikram@email.com', '9876543211'),
(7, 'Anjali Mehta', 'anjali@email.com', '9988776656'),
(8, 'Rahul Gupta', 'rahul@email.com', '9123456790'),
(9, 'Pooja Sharma', 'pooja@email.com', '9444555667'),
(10, 'Arjun Reddy', 'arjun@email.com', '9333222112'),
(11, 'Kavita Patel', 'kavita@email.com', '9555444334'),
(12, 'Nitin Kumar', 'nitin@email.com', '9666777889'),
(13, 'Divya Iyer', 'divya@email.com', '9777888990'),
(14, 'Siddharth Jain', 'siddharth@email.com', '9888999001'),
(15, 'Rashmi Tiwari', 'rashmi@email.com', '9999000112');

INSERT INTO SHOWTIMES VALUES
(6, 6, '2024-01-20', '14:00:00', 'PVR Cinemas'),
(7, 6, '2024-01-20', '18:30:00', 'INOX Mall'),
(8, 7, '2024-01-21', '15:00:00', 'Cinepolis'),
(9, 8, '2024-01-22', '20:00:00', 'PVR Cinemas'),
(10, 9, '2024-01-23', '13:00:00', 'INOX Mall'),
(11, 10, '2024-01-24', '16:00:00', 'Cinepolis'),
(12, 1, '2024-01-25', '19:00:00', 'PVR Cinemas'), -- Duplicate movie
(13, 2, '2024-01-26', '21:00:00', 'INOX Mall'),   -- Duplicate movie
(14, 3, '2024-01-27', '12:00:00', 'Cinepolis'),  -- Duplicate movie
(15, 4, '2024-01-28', '17:00:00', 'PVR Cinemas'); -- Duplicate movie


INSERT INTO BOOKINGS VALUES
-- Duplicate amounts for RANK() practice
(7, 6, 6, 2, 560.00, '2024-01-15'),  -- Same as booking 1 amount
(8, 7, 7, 3, 960.00, '2024-01-16'),  -- High amount
(9, 8, 8, 1, 260.00, '2024-01-17'),  -- Low amount
(10, 9, 9, 4, 960.00, '2024-01-18'), -- Same as booking 8 (duplicate amount)
(11, 10, 10, 2, 700.00, '2024-01-19'), 
(12, 6, 11, 3, 840.00, '2024-01-20'),
(13, 7, 12, 1, 250.00, '2024-01-21'), -- Same as Pathaan price
(14, 8, 13, 2, 600.00, '2024-01-22'), -- Same as Jawan × 2
(15, 9, 14, 3, 1050.00, '2024-01-23'), -- High amount
(16, 10, 15, 1, 200.00, '2024-01-24'), -- Same as RRR price
(17, 11, 1, 2, 500.00, '2024-01-25'), -- Duplicate of booking 1
(18, 12, 2, 1, 300.00, '2024-01-26'), -- Duplicate of Jawan price
(19, 13, 3, 2, 700.00, '2024-01-27'), -- Duplicate amount
(20, 14, 4, 3, 600.00, '2024-01-28'), -- Duplicate amount
(21, 15, 5, 1, 280.00, '2024-01-29'), -- Duplicate of Brahmastra
(22, 6, 6, 1, 280.00, '2024-01-30'), -- Duplicate amount
(23, 7, 7, 2, 640.00, '2024-01-31'), -- New amount
(24, 8, 8, 3, 780.00, '2024-02-01'), -- New amount
(25, 9, 9, 2, 480.00, '2024-02-02'), -- New amount
(26, 10, 10, 1, 350.00, '2024-02-03'); -- New amount


SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS total FROM CUSTOMERS
UNION ALL
SELECT 'MOVIES', COUNT(*) FROM MOVIES
UNION ALL
SELECT 'SHOWTIMES', COUNT(*) FROM SHOWTIMES
UNION ALL
SELECT 'BOOKINGS', COUNT(*) FROM BOOKINGS;


-- Check duplicate amounts in BOOKINGS (for RANK practice)
SELECT total_amount, COUNT(*) as count
FROM BOOKINGS
GROUP BY total_amount
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- Check duplicate ratings in MOVIES (for GROUP BY practice)
SELECT imdb_rating, COUNT(*) as count
FROM MOVIES
GROUP BY imdb_rating
HAVING COUNT(*) > 1
ORDER BY imdb_rating DESC;

-- See difference with duplicate amounts
SELECT 
    customer_id,
    total_amount,
    ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS row_num,
    RANK() OVER (ORDER BY total_amount DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rank_num
FROM BOOKINGS;
use movie_booking;


SELECT 
C.CUSTOMER_ID,
C.NAME,
B.TOTAL_AMOUNT,
DENSE_RANK() OVER (PARTITION BY B.CUSTOMER_ID ORDER BY B.TOTAL_AMOUNT DESC) AS RANK_BASED_ON_GROUP
 FROM BOOKINGS B
JOIN CUSTOMERS C ON B.CUSTOMER_ID=C.CUSTOMER_ID;

SELECT 'CUSTOMERS' as table_name, COUNT(*) as total FROM CUSTOMERS
UNION ALL
SELECT 'MOVIES', COUNT(*) FROM MOVIES
UNION ALL
SELECT 'SHOWTIMES', COUNT(*) FROM SHOWTIMES
UNION ALL
SELECT 'BOOKINGS', COUNT(*) FROM BOOKINGS;

-- Create two sample tables for demonstration
CREATE TABLE ACTION_MOVIES (
    movie_id INT,
    title VARCHAR(100),
    rating DECIMAL(3,1)
);

CREATE TABLE COMEDY_MOVIES (
    movie_id INT,
    title VARCHAR(100),
    rating DECIMAL(3,1)
);

-- Insert sample data with some duplicates
INSERT INTO ACTION_MOVIES VALUES
(1, 'Pathaan', 7.0),
(2, 'Jawan', 8.0),
(3, 'Animal', 6.5),
(4, 'RRR', 8.1),
(5, 'Tiger 3', 6.8);

INSERT INTO COMEDY_MOVIES VALUES
(6, 'OMG 2', 7.5),
(7, 'Bhool Bhulaiyaa 2', 6.9),
(8, 'Pathaan', 7.0),  -- DUPLICATE! Same as Action Movies
(9, 'Jawan', 8.0),     -- DUPLICATE! Same as Action Movies
(10, 'Dream Girl 2', 6.2);

SELECT title, rating FROM ACTION_MOVIES
UNION 
SELECT title, rating FROM COMEDY_MOVIES;

-- High-rated movies from both genres (remove duplicates)
SELECT title, rating FROM ACTION_MOVIES WHERE rating > 7.0
UNION
SELECT title, rating FROM COMEDY_MOVIES WHERE rating > 7.0;

-- Same but keep duplicates
SELECT title, rating FROM ACTION_MOVIES WHERE rating > 7.0
UNION ALL 
SELECT title, rating FROM COMEDY_MOVIES WHERE rating > 7.0;
use movie_booking;

SELECT TITLE,RATING FROM ACTION_MOVIES WHERE RATING >= 7
UNION ALL
SELECT TITLE,RATING FROM COMEDY_MOVIES WHERE RATING <= 7;

SELECT TITLE,RATING FROM ACTION_MOVIES WHERE RATING >8
UNION
SELECT TITLE,RATING FROM COMEDY_MOVIES WHERE RATING >6;

-- Easy to understand step by step
WITH CustomerSpending AS (
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rn
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
SELECT * FROM CustomerSpending WHERE rn <= 3;

-- Goal: Find customers who spent more than average

WITH 
-- CTE 1: Calculate customer spending
CustomerSpending AS (
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
),

-- CTE 2: Calculate average spending
AverageSpending AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM CustomerSpending
)

-- Final Query: Use both CTEs
SELECT 
    cs.NAME,
    cs.total_spent,
    asp.avg_spent,
    CASE 
        WHEN cs.total_spent > asp.avg_spent THEN 'ABOVE_AVERAGE'
        ELSE 'BELOW_AVERAGE'
    END AS status
FROM CustomerSpending cs
CROSS JOIN AverageSpending asp
WHERE cs.total_spent > asp.avg_spent;

-- Find customers with total spending > ₹1000
WITH HighValueCustomers AS (
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
    HAVING SUM(B.TOTAL_AMOUNT) > 1000
)
SELECT * FROM HighValueCustomers ORDER BY total_spent DESC;


WITH C_S AS (
    SELECT  
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS TOTAL_KHARCHA
    FROM CUSTOMERS C 
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
),
C_RANKED AS (
    SELECT 
        NAME,
        TOTAL_KHARCHA,
        ROW_NUMBER() OVER (ORDER BY TOTAL_KHARCHA DESC) AS RUN
    FROM C_S
)
SELECT *
FROM C_RANKED
WHERE RUN < 5;


-- Easy to understand step by step
WITH CustomerSpending AS (
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rn
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
SELECT * FROM CustomerSpending WHERE rn <= 3;

WITH C_S AS (
    SELECT  
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS TOTAL_KHARCHA,  -- ✅ Added comma here!
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS RUN
    FROM CUSTOMERS C 
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
SELECT * FROM C_S WHERE RUN < 4;

WITH HVC AS (
SELECT
C.NAME,
SUM(B.TOTAL_AMOUNT) AS T_S
FROM CUSTOMERS C JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID,C.NAME
HAVING SUM(B.TOTAL_AMOUNT) >1000 )
SELECT * FROM HVC ORDER BY T_S DESC;
use movie_booking;
SHOW TABLES;

SELECT
CUSTOMER_ID,
TOTAL_AMOUNT,
LEAD(TOTAL_AMOUNT) OVER (ORDER BY TOTAL_AMOUNT DESC) AS RUNNING_TOTAL FROM BOOKINGS;

SELECT 
CUSTOMER_ID,
TOTAL_AMOUNT,
ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY TOTAL_AMOUNT DESC) AS CUSTOMER_RANK FROM BOOKINGS;


WITH CustomerSpending AS (
    -- This is your DRAFT PAPER
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
-- STOP HERE FIRST! See what's in your draft:
SELECT * FROM CustomerSpending;

WITH CustomerSpending AS (
    -- DRAFT PAPER with spending + ranking
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rank_num
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
-- See your enhanced draft:
SELECT * FROM CustomerSpending;

WITH CustomerSpaging AS (
    -- DRAFT PAPER
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rank_num
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
-- FINAL ANSWER using draft:
SELECT * FROM CustomerSpending WHERE rank_num <= 3;

WITH CustomerSpaging AS (
    -- DRAFT PAPER
    SELECT 
        C.NAME,
        SUM(B.TOTAL_AMOUNT) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(B.TOTAL_AMOUNT) DESC) AS rank_num
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.CUSTOMER_ID = B.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, C.NAME
)
-- FINAL ANSWER using draft:
SELECT * FROM CustomerSpending WHERE rank_num <= 3;

-- Create a draft with movie titles and prices
WITH MovieList AS (
    SELECT title, ticket_price FROM MOVIES
)
-- Use the draft:
SELECT * FROM MovieList;

-- Draft with GST calculation
WITH MoviePrices AS (
    SELECT 
        title,
        ticket_price,
        ticket_price * 1.18 AS price_with_gst
    FROM MOVIES
)
SELECT * FROM MoviePrices;


WITH MovieList AS (
    SELECT title, ticket_price FROM MOVIES
)
SELECT * FROM MovieList;

WITH movielist AS (
    SELECT title, ticket_price
    FROM movies
)
SELECT *
FROM movielist;

WITH movielist AS (
              select title, ticket_price from MOVIES
              )
select * from movielist;

WITH INDIAN_LIST AS (SELECT GENRE,TICKET_PRICE FROM MOVIES)
SELECT * FROM INDIAN_LIST;

create table indian_boys (
   age int primary key,
   name varchar(50),
   lulli_age int)
 ;
select * from indian_boys;

insert into indian_boys values (1, 'kawaa', 34);
use movie_booking;

with customertotal as (
select 
c.name,
sum(b.total_amount) as total_spent
from customers c
join bookings b on c.customer_id=b.customer_id
group by c.customer_id,c.name)
SELECT * FROM CustomerTotal;
-- --top 2 spenders 
with customertotal AS (
select 
c.name,
sum(b.total_amount) as total_spent,
row_number() over (order by sum(b.total_amount) desc) as rank_num
from customers c
join bookings b on c.customer_id=b.customer_id
group by  c.customer_Id,c.name
)
select * from customertotal where rank_num <=2;

-- WITH draft_name AS (
--     -- Tumhara query yahan
-- )
-- SELECT * FROM draft_name;

with customertotal as (
select 
c.name,
sum(b.total_amount) as total_spent,
row_number() over (order by sum(b.total_amount) desc) as rank_num
from customers c 
join bookings b on c.customer_id=b.customer_id
group by c.customer_id,c.name
)
select  * from customertotal where rank_num <=3;

with customertotal as (
select
c.name,
sum(b.total_amount) as tota_spent
from customers c join bookings b on
c.customer_id=b.customer_id
group by c.customer_id,c.name
)
select * from customertotal where tota_spent >1000;

-- Goal: Show customer names with total spending
WITH customertota AS (
    SELECT 
        c.name,
        sum(b.total_amount) as tota_spent
        from customers c join bookings b on
        c.customer_id=b.customer_id

    GROUP BY c.customer_id,c.name
)
SELECT * FROM customertota;

select 'i am learnig indian ' as message;
select concat(name,'  ','indian chuche') from customers;

desc  indian_boys;
use movie_booking;
 
 with custo as ( select
 name,
 sum(b.total_amount) as all_kharcha
from customers c join bookings b on
c.customer_id=b.customer_id
group by c.customer_id,c.name )

select * from custo ;

-- 1️⃣ INDEXES banao (15 min)
USE MOVIE_BOOKING;

-- Create indexes for faster queries
CREATE INDEX idx_cust_id ON BOOKINGS(customer_id);
CREATE INDEX idx_movie_genre ON MOVIES(genre);
CREATE INDEX idx_booking_date ON BOOKINGS(booking_date);

-- Check indexes
SHOW INDEX FROM BOOKINGS;

-- 2️⃣ VIEWS create karo (30 min)
-- Customer ka full summary view
CREATE VIEW CustomerDashboard AS
SELECT 
    C.customer_id,
    C.name,
    C.email,
    COUNT(B.booking_id) as total_bookings,
    COALESCE(SUM(B.total_amount), 0) as lifetime_value,
    COALESCE(MAX(B.booking_date), 'Never') as last_booking
FROM CUSTOMERS C
LEFT JOIN BOOKINGS B ON C.customer_id = B.customer_id
GROUP BY C.customer_id;

-- Use the view
SELECT * FROM CustomerDashboard;

-- 3️⃣ STORED PROCEDURE banao (45 min)
DELIMITER //
CREATE PROCEDURE GetCustomerHistory(IN cust_id INT)
BEGIN
    -- Customer details
    SELECT * FROM CUSTOMERS WHERE customer_id = cust_id;
    
    -- Booking history
    SELECT 
        B.booking_id,
        M.title,
        B.booking_date,
        B.total_amount
    FROM BOOKINGS B
    JOIN SHOWTIMES S ON B.showtime_id = S.showtime_id
    JOIN MOVIES M ON S.movie_id = M.movie_id
    WHERE B.customer_id = cust_id;
    
    -- Total summary
    SELECT 
        COUNT(*) as total_bookings,
        SUM(total_amount) as total_spent
    FROM BOOKINGS
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- Call procedure
CALL GetCustomerHistory(1);

-- 4️⃣ TRANSACTIONS practice (30 min)
START TRANSACTION;

-- New booking process
INSERT INTO BOOKINGS VALUES 
(100, 1, 1, 2, 500.00, CURDATE());

-- Check if inserted
SELECT * FROM BOOKINGS WHERE booking_id = 100;

-- If happy, commit
COMMIT;
-- If mistake, rollback
-- ROLLBACK;

-- 🎯 Problem 1: Find customers who booked consecutive days
WITH BookingDates AS (
    SELECT 
        customer_id,
        booking_date,
        LAG(booking_date) OVER (PARTITION BY customer_id ORDER BY booking_date) as prev_date
    FROM BOOKINGS
)
SELECT DISTINCT customer_id 
FROM BookingDates
WHERE DATEDIFF(booking_date, prev_date) = 1;

-- 🎯 Problem 2: Top movie by each genre
WITH GenreRanking AS (
    SELECT 
        M.genre,
        M.title,
        COUNT(B.booking_id) as bookings,
        ROW_NUMBER() OVER (PARTITION BY M.genre ORDER BY COUNT(B.booking_id) DESC) as rn
    FROM MOVIES M
    LEFT JOIN SHOWTIMES S ON M.movie_id = S.movie_id
    LEFT JOIN BOOKINGS B ON S.showtime_id = B.showtime_id
    GROUP BY M.genre, M.title
)
SELECT genre, title, bookings
FROM GenreRanking
WHERE rn = 1;

-- 🎯 Problem 3: Customer retention (returning customers)
WITH FirstBooking AS (
    SELECT 
        customer_id,
        MIN(booking_date) as first_booking
    FROM BOOKINGS
    GROUP BY customer_id
),
ReturningCustomers AS (
    SELECT 
        B.customer_id,
        FB.first_booking,
        COUNT(DISTINCT B.booking_date) as booking_days
    FROM BOOKINGS B
    JOIN FirstBooking FB ON B.customer_id = FB.customer_id
    WHERE B.booking_date > FB.first_booking
    GROUP BY B.customer_id, FB.first_booking
)
SELECT 
    COUNT(DISTINCT customer_id) as returning_customers,
    (COUNT(DISTINCT customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM BOOKINGS)) as retention_rate
FROM ReturningCustomers;

-- 🎯 Problem 4: Moving average of bookings
SELECT 
    booking_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY booking_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3days
FROM BOOKINGS
ORDER BY booking_date;

-- 🎯 Problem 5: Percentile ranking
SELECT 
    C.name,
    B.total_amount,
    PERCENT_RANK() OVER (ORDER BY B.total_amount) * 100 as percentile
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.customer_id = B.customer_id;

SELECT CUSTOMER_ID,EMAIL FROM CUSTOMERS;

SELECT NAME FROM CUSTOMERS WHERE CUSTOMER_ID=2;
SELECT TITLE,TICKET_PRICE FROM MOVIES ;
DESC MOVIES;
SELECT TITLE, TICKET_PRICE FROM MOVIES WHERE TICKET_PRICE  >300;

SELECT 
C.NAME,
B.TOTAL_AMOUNT
FROM CUSTOMERS C JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID;

SELECT 
C.NAME AS "CUSTOMER KA NAAM",
B.TOTAL_AMOUNT AS "PAISA"
FROM CUSTOMERS C JOIN BOOKINGS B ON C.CUSTOMER_ID=B.CUSTOMER_ID;

SELECT
CUSTOMER_ID,
COUNT(*) AS 'KITNI BAAR'
FROM BOOKINGS GROUP BY CUSTOMER_ID;

SELECT 
CUSTOMER_ID,
SUM(TOTAL_AMOUNT) AS 'TOTA PAISA'
FROM BOOKINGS GROUP BY CUSTOMER_ID;

SELECT
C.NAME,
SUM(TOTAL_AMOUNT) AS 'TOL_TAXA'
FROM CUSTOMERS C CROSS JOIN BOOKINGS B ON
C.CUSTOMER_ID=B.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME;
use movie_booking;

SELECT 
    C.customer_id,
    C.name,
    B.booking_id,
    B.total_amount
FROM CUSTOMERS C
INNER JOIN BOOKINGS B 
    ON C.customer_id = B.customer_id;
    
    SELECT 
    C.customer_id,
    C.name,
    B.booking_id,
    B.total_amount
FROM CUSTOMERS C
LEFT JOIN BOOKINGS B 
    ON C.customer_id = B.customer_id;
    
    SELECT 
    C.customer_id,
    C.name,
    B.booking_id
FROM CUSTOMERS C
RIGHT JOIN BOOKINGS B
    ON C.customer_id = B.customer_id;
    
    -- Example: saare cities × saare payment methods
SELECT 
    DISTINCT C.city,
    B.payment_method
FROM CUSTOMERS C
JOIN BOOKINGS B;
use movie_booking;
select 'i was playing an indinesian game doing indian' as message;

SELECT
CUSTOMER_ID,
TOTAL_AMOUNT,
LEAD(TOTAL_AMOUNT) OVER (ORDER  BY TOTAL_AMOUNT DESC) AS PREVENT_AMOUNT
FROM BOOKINGS;

use movie_booking;
show tables;
desc bookings;
select count(*) from customers;
select count(*) from bookings;

select
c.name,
sum(b.total_amount) as total_kharcha
-- b.total_amount
from customers c join bookings b on 
c.customer_id=b.customer_id;
-- This is your "hello world" - you wrote this before!
SELECT 
    C.name,
    SUM(B.total_amount) AS total_spent
FROM CUSTOMERS C
JOIN BOOKINGS B ON C.customer_id = B.customer_id
GROUP BY C.customer_id, C.name
ORDER BY total_spent DESC;

-- Add one more thing - ranking
WITH CustomerSpending AS (
    SELECT 
        C.name,
        SUM(B.total_amount) AS total_spent
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.customer_id = B.customer_id
    GROUP BY C.customer_id, C.name
)
SELECT 
    *,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rank_num
FROM CustomerSpending
LIMIT 5;
SELECT * FROM BOOKINGS ;

SELECT CURDate();
select now();

SELECT 
YEAR(BOOKING_DATE) AS SAAAL ,
MONTH(BOOKING_DATE) MAHEEENA_AAYA,
DAY(BOOKING_DATE)
FROM BOOKINGS;

SELECT
BOOKING_DATE,
DATE_ADD(BOOKING_DATE,INTERVAL 7 DAY) AS NEXT_WEEK,
DATEDIFF(CURDATE(), BOOKING_DATE) AS DAYS_AGO
 FROM BOOKINGS;
 
 
-- Group by month
SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_revenue
FROM BOOKINGS
GROUP BY DATE_FORMAT(booking_date,'%Y-%m');

SELECT 
 date_format(booking_date,'%y-%m') as month,
 sum(total_amount) as monthly_revenue
 from bookings
group by date_format(booking_date,'%y-%m');
 
 -- "Show monthly revenue trend for last 6 months"
SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS month,
    COUNT(*) AS orders,
    SUM(total_amount) AS revenue
FROM BOOKINGS
WHERE booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY month;
use movie_booking;
-- Clean customer names and show email domains
SELECT 
    TRIM(UPPER(C.name)) AS clean_name,
    SUBSTRING(C.email, LOCATE('@', C.email)+1) AS email_domain
FROM CUSTOMERS C;
-- See what TRIM and UPPER do
SELECT 
    name,
    UPPER(name) AS upper_name,
    TRIM(UPPER(name)) AS clean_name
FROM CUSTOMERS;
-- See where @ is located
SELECT 
    email,
    LOCATE('@', email) AS at_position
FROM CUSTOMERS;

-- Show monthly revenue for your movie bookings
SELECT 
    DATE_FORMAT(B.booking_date, '%Y-%m') AS month,
    COUNT(*) AS total_bookings,
    SUM(B.total_amount) AS monthly_revenue
FROM BOOKINGS B
GROUP BY DATE_FORMAT(B.booking_date, '%Y-%m')
ORDER BY month;
-- Only needed for procedures/functions
DELIMITER $$

CREATE PROCEDURE ShowHighValueCustomers()
BEGIN
    SELECT 
        C.name,
        SUM(B.total_amount) AS total_spent
    FROM CUSTOMERS C
    JOIN BOOKINGS B ON C.customer_id = B.customer_id
    GROUP BY C.customer_id, C.name
    HAVING SUM(B.total_amount) > 1000
    ORDER BY total_spent DESC;
END$$

DELIMITER ;

-- Now call it anytime:
CALL ShowHighValueCustomers();