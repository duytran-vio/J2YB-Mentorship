--The runner table contains the following columns:
--	id stores the unique ID of the runner.
--	name stores the runner's name.
--	main_distance stores the distance (in meters) that the runner runs during events.
--	age stores the runner's age.
--	is_female indicates if the runner is male or female.
--
--The event table contains the following columns:
--	id stores the unique ID of the event.
--	name stores the name of the event (e.g. London Marathon, Warsaw Runs, or New Year Run).
--	start_date stores the date of the event.
--	city stores the city where the event takes place.
--	
--The runner_event table contains the following columns:
--	runner_id stores the ID of the runner.
--	event_id stores the ID of the event.
--
--
--1. Create tables 
--
--2. Organize Runners Into Groups
--Select the main distance and the number of runners that run the given distance (runners_number). Display only those rows where the number of runners is greater than 3.
--
--3.How Many Runners Participate in Each Event
--Display the event name and the number of club members that take part in this event (call this column runner_count). Note that there may be events in which no club 
--members participate. For these events, the runner_count should equal 0.
--
--4.Group Runners by Main Distance and Age
--Display the distance and the number of runners there are for the following age categories: under 20, 20–29, 30–39, 40–49, and over 50. 
--Use the following column aliases: under_20, age_20_29, age_30_39, age_40_49, and over_50.

-- Drop existing tables if they exist
CREATE SCHEMA session2;
SET search_path = session2;

DROP TABLE IF EXISTS runner_event;
DROP TABLE IF EXISTS runner;
DROP TABLE IF EXISTS event;

-- Create runner table
CREATE TABLE runner (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    main_distance INTEGER,
    age INTEGER,
    is_female BOOLEAN
);

-- Create event table
CREATE TABLE event (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    start_date DATE,
    city VARCHAR(100)
);

-- Create runner_event table
CREATE TABLE runner_event (
    runner_id INTEGER,
    event_id INTEGER,
    FOREIGN KEY (runner_id) REFERENCES runner(id),
    FOREIGN KEY (event_id) REFERENCES event(id)
);

-- Insert mock data into runner table
INSERT INTO runner (id, name, main_distance, age, is_female) VALUES
(1, 'John Doe', 5000, 25, FALSE),       -- 20-29
(2, 'Jane Smith', 10000, 28, TRUE),     -- 20-29
(3, 'Alice Johnson', 800, 22, TRUE),   -- 20-29
(4, 'Bob Brown', 800, 30, FALSE),       -- 30-39
(5, 'Charlie Davis', 10000, 35, FALSE), -- 30-39
(6, 'David Harris', 10000, 18, FALSE),   -- Under 20
(7, 'Ella Wilson', 800, 27, TRUE),      -- 20-29
(8, 'Fiona White', 5000, 24, TRUE),     -- 20-29
(9, 'George Black', 5000, 32, FALSE),   -- 30-39
(10, 'Helen Green', 3000, 29, TRUE),    -- 20-29
(11, 'Ian Clark', 3000, 31, FALSE),     -- 30-39
(12, 'Jack Lewis', 800, 40, FALSE),     -- 40-49
(13, 'Karen Walker', 1500, 17, TRUE),   -- Under 20
(14, 'Liam Hall', 10000, 33, FALSE),    -- 30-39
(15, 'Mia Young', 5000, 23, TRUE),      -- 20-29
(16, 'Noah King', 2000, 26, FALSE),     -- 20-29
(17, 'Olivia Scott', 1500, 24, TRUE),   -- 20-29
(18, 'Paul Adams', 10000, 35, FALSE),   -- 30-39
(19, 'Quincy Baker', 800, 32, FALSE),   -- 30-39
(20, 'Rachel Carter', 800, 55, TRUE);  -- Over 50

-- Insert mock data into event table
INSERT INTO event (id, name, start_date, city) VALUES
(1, 'London Marathon', '2023-04-23', 'London'),
(2, 'Warsaw Runs', '2023-05-10', 'Warsaw'),
(3, 'New Year Run', '2024-01-01', 'New York'),
(4, 'Summer Sprint', '2023-06-15', 'Los Angeles'),
(5, 'Autumn Jog', '2023-09-10', 'Boston'),
(6, 'Dublin Palace', '2023-10-10', 'Boston');

-- Insert mock data into runner_event table
INSERT INTO runner_event (runner_id, event_id) VALUES
(1, 1),
(2, 1),
(3, 4),
(4, 5),
(5, 2),
(6, 3),
(7, 1),
(8, 2),
(9, 4),
(10, 5),
(11, 3),
(12, 2),
(13, 4),
(14, 1),
(15, 2),
(16, 3),
(17, 4),
(18, 1),
(19, 5),
(20, 2);

--2. Organize Runners Into Groups
--Select the main distance and the number of runners that run the given distance (runners_number). Display only those rows where the number of runners is greater than 3.

SELECT
	r.main_distance,
	count(r.id)
FROM session2.runner r
GROUP BY r.main_distance
HAVING count(r.id) >= 3;

--3.How Many Runners Participate in Each Event
--Display the event name and the number of club members that take part in this event (call this column runner_count). Note that there may be events in which no club 
--members participate. For these events, the runner_count should equal 0.

SELECT 
	e.id AS event_id,
	count(re.runner_id) AS runner_count
FROM session2."event" e
LEFT JOIN session2.runner_event re ON e.id=re.event_id
GROUP BY e.id
ORDER BY e.id;

--4.Group Runners by Main Distance and Age
--Display the distance and the number of runners there are for the following age categories: under 20, 20–29, 30–39, 40–49, and over 50. 
--Use the following column aliases: under_20, age_20_29, age_30_39, age_40_49, and over_50.
SELECT
    COUNT(CASE WHEN r.age < 20 THEN 1 END) AS under_20,
    COUNT(CASE WHEN r.age BETWEEN 20 AND 29 THEN 1 END) AS age_20_29,
    COUNT(CASE WHEN r.age BETWEEN 30 AND 39 THEN 1 END) AS age_30_39,
    COUNT(CASE WHEN r.age BETWEEN 40 AND 49 THEN 1 END) AS age_40_49,
    COUNT(CASE WHEN r.age >= 50 THEN 1 END) AS over_50
FROM runner r;













