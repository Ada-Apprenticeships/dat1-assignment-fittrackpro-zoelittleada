-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
-- I ran this multiple times so this has inserted multiple times 

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, datetime('now'), 'Credit Card', 'Monthly membership fee');

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year

SELECT strftime('%Y-%m', payment_date) AS month, SUM(amount) AS total_revenue
FROM payments
WHERE payment_date BETWEEN date('now', '-1 year') AND date('now', '-1 day')
AND payment_type = 'Monthly membership fee'
GROUP BY month
ORDER BY month;

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases

SELECT payment_id, amount, payment_date, payment_method
FROM payments
WHERE payment_type = 'Day pass';