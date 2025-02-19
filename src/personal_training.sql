-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer

SELECT session_id, (m.first_name || ' ' || m.last_name) AS member_name, session_date, start_time, end_time 
FROM staff s
JOIN personal_training_sessions pts ON s.staff_id = pts.staff_id
JOIN members m ON pts.member_id = m.member_id
WHERE s.first_name = 'Ivy'
AND s.last_name = 'Irwin';
