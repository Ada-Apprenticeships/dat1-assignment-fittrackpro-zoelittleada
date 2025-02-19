-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role

SELECT staff_id, first_name, last_name, position as role
FROM staff;

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

SELECT s.staff_id AS trainer_id, (first_name || ' ' || last_name) AS trainer_name, COUNT(pts.staff_id) AS session_count
FROM staff s
JOIN personal_training_sessions pts ON s.staff_id = pts.staff_id
WHERE position = 'Trainer'  
AND pts.session_date BETWEEN date('now') AND date('now', '+30 days')
GROUP BY trainer_id
HAVING COUNT(pts.staff_id) > 0;