-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column
--.read data/sample_data.sql

-- Enable foreign key support
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments ;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, 
    address TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    email TEXT NOT NULL, 
    opening_hours TEXT NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL, 
    email TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    date_of_birth DATE NOT NULL, 
    join_date DATE NOT NULL, 
    emergency_contact_name TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL, 
    email TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    position TEXT CHECK (position IN ('Manager', 'Receptionist', 'Trainer', 'Maintenance')) NOT NULL,
    hire_date DATE NOT NULL, 
    location_id INTEGER, 
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT NOT NULL, 
    type TEXT CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL, 
    last_maintenance_date DATE NOT NULL, 
    next_maintenance_date DATE NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT NOT NULL, 
    description TEXT NOT NULL, 
    capacity INTEGER NOT NULL, 
    duration TEXT NOT NULL, 
    location_id INTEGER, 
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    class_id INTEGER, 
    staff_id INTEGER, 
    start_time TIME NOT NULL, 
    end_time TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_d INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER, 
    type VARCHAR(30) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date DATE NOT NULL, 
    status TEXT CHECK (status IN ('Active', 'Inactive')) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance ( 
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    member_id INTEGER, 
    location_id INTEGER, 
    check_in_time DATETIME, 
    check_out_time DATETIME,
    CHECK (
        (check_in_time IS NOT NULL AND check_out_time IS NOT NULL) 
        AND 
        (check_in_time < check_out_time)
    ),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    schedule_id INTEGER, 
    member_id INTEGER, 
    attendance_status TEXT CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')) NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    member_id INTEGER,
    amount DECIMAL(2,2) NOT NULL, 
    payment_date DATE NOT NULL, 
    payment_method TEXT CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')) NOT NULL,
    payment_type TEXT CHECK (payment_type IN ('Monthly membership fee', 'Day pass')) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER, 
    staff_id INTEGER, 
    session_date DATE NOT NULL, 
    start_time TIME NOT NULL, 
    end_time TIME NOT NULL, 
    notes VARCHAR(200),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    member_id INTEGER, 
    measurement_date DATE NOT NULL, 
    weight DECIMAL(2,1) NOT NULL,
    body_fat_percentage DECIMAL(2,1) NOT NULL, 
    muscle_mass DECIMAL(2,1) NOT NULL, 
    bmi DECIMAL(2,1) NOT NULL, 
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER, 
    maintenance_date DATE NOT NULL, 
    description VARCHAR(200),
    staff_id INTEGER, 
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- 1. locations
-- 2. members
-- 3. staff
-- 4. equipment
-- 5. classes
-- 6. class_schedule
-- 7. memberships
-- 8. attendance
-- 9. class_attendance
-- 10. payments
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal