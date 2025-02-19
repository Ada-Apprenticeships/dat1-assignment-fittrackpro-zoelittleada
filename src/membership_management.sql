-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships

SELECT m.member_id, first_name, last_name, type AS membership_type, join_date
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE ms.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

SELECT ms.type AS membership_type, CAST(AVG(strftime('%s', a.check_out_time) - strftime('%s', a.check_in_time)) AS REAL) / 60 AS average_duration_minutes
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
JOIN attendance a ON m.member_id = a.member_id
GROUP BY ms.type;

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

SELECT m.member_id, first_name, last_name, email, end_date 
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE ms.end_date BETWEEN DATE('now') AND DATE('now', '+1 year');
