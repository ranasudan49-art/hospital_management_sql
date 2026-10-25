-- ASSIGNMENT III: SQL TABLE MANIPULATION
-- Business Idea: Hospital Management System
-- DBMS: PostgreSQL
-- rana_202510331_hospital_management

-- ============================================================
-- 1. DATABASE CREATION
-- ============================================================
CREATE DATABASE rana_202510331_hospital_management;

-- In pgAdmin: open the new database, then run everything below.

-- ============================================================
-- 2. TABLE CREATION
-- ============================================================

DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;

CREATE TABLE patients (
    patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age >= 0),
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('Male', 'Female')),
    phone VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE doctors (
    doctor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE visits (
    visit_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(150) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- ============================================================
-- 3. INITIAL DATA INSERTION
-- At least 5 records in every table
-- ============================================================

INSERT INTO patients (full_name, age, gender, phone) VALUES
('Alice Uwase', 24, 'Female', '0781000001'),
('Brian Niyonzima', 31, 'Male', '0781000002'),
('Claudine Mukamana', 28, 'Female', '0781000003'),
('David Habimana', 45, 'Male', '0781000004'),
('Esther Ingabire', 36, 'Female', '0781000005');

INSERT INTO doctors (doctor_name, specialty, phone) VALUES
('Dr. Jean Claude', 'Cardiology', '0782000001'),
('Dr. Grace Mukamana', 'Pediatrics', '0782000002'),
('Dr. Eric Nkurunziza', 'General Medicine', '0782000003'),
('Dr. Alice Uwamahoro', 'Dermatology', '0782000004'),
('Dr. Patrick Mugisha', 'Orthopedics', '0782000005');

INSERT INTO visits (patient_id, doctor_id, visit_date, diagnosis) VALUES
((SELECT patient_id FROM patients WHERE phone = '0781000001'),
 (SELECT doctor_id FROM doctors WHERE phone = '0782000003'),
 '2026-10-20', 'Malaria'),

((SELECT patient_id FROM patients WHERE phone = '0781000002'),
 (SELECT doctor_id FROM doctors WHERE phone = '0782000001'),
 '2026-10-21', 'High blood pressure'),

((SELECT patient_id FROM patients WHERE phone = '0781000003'),
 (SELECT doctor_id FROM doctors WHERE phone = '0782000002'),
 '2026-10-21', 'Flu'),

((SELECT patient_id FROM patients WHERE phone = '0781000004'),
 (SELECT doctor_id FROM doctors WHERE phone = '0782000005'),
 '2026-10-22', 'Back pain'),

((SELECT patient_id FROM patients WHERE phone = '0781000005'),
 (SELECT doctor_id FROM doctors WHERE phone = '0782000004'),
 '2026-10-23', 'Skin allergy');

-- Verify initial records
SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM visits;

-- ============================================================
-- 4. SELECT TASKS
-- ============================================================

-- Q1.1 Basic Data Retrieval
-- Objective: Display patient names, ages, and genders.
SELECT full_name, age, gender
FROM patients;

-- Q1.2 Conditional Data Retrieval
-- Objective: Find patients older than 30.
SELECT patient_id, full_name, age
FROM patients
WHERE age > 30;

-- Q1.3 Sorted Data Retrieval
-- Objective: Display patients from youngest to oldest.
SELECT patient_id, full_name, age
FROM patients
ORDER BY age ASC;

-- ============================================================
-- 5. JOIN TASKS
-- ============================================================

-- Q2.1 INNER JOIN
-- Objective: Show visits that have matching patient records.
SELECT
    v.visit_id,
    p.full_name,
    v.visit_date,
    v.diagnosis
FROM visits AS v
INNER JOIN patients AS p
    ON v.patient_id = p.patient_id;

-- Q2.2 LEFT JOIN
-- Objective: Show all patients and their visits when available.
SELECT
    p.full_name,
    v.visit_date,
    v.diagnosis
FROM patients AS p
LEFT JOIN visits AS v
    ON p.patient_id = v.patient_id
ORDER BY p.full_name;

-- Q2.3 Multi-Table JOIN
-- Objective: Combine patients, doctors, and visits into one report.
SELECT
    p.full_name AS patient_name,
    d.doctor_name,
    d.specialty,
    v.visit_date,
    v.diagnosis
FROM visits AS v
JOIN patients AS p
    ON v.patient_id = p.patient_id
JOIN doctors AS d
    ON v.doctor_id = d.doctor_id
ORDER BY v.visit_date;

-- ============================================================
-- 6. UPDATE TASKS
-- ============================================================

-- Q3.1 Update One Record
-- Objective: Change one patient's phone number.
UPDATE patients
SET phone = '0781999999'
WHERE patient_id = (
    SELECT patient_id
    FROM patients
    WHERE full_name = 'Alice Uwase'
);

-- Verify
SELECT * FROM patients
WHERE full_name = 'Alice Uwase';

-- Q3.2 Update Multiple Records
-- Objective: Add 1 year to the age of patients currently older than 30.
UPDATE patients
SET age = age + 1
WHERE age > 30;

-- Verify
SELECT patient_id, full_name, age
FROM patients
WHERE age > 30
ORDER BY patient_id;

-- Q3.3 Conditional Update
-- Objective: Apply a business rule: classify a visit diagnosis for patients
-- whose diagnosis is currently 'Malaria'.
UPDATE visits
SET diagnosis = 'Malaria - Follow-up Required'
WHERE diagnosis = 'Malaria';

-- Verify
SELECT * FROM visits
WHERE diagnosis = 'Malaria - Follow-up Required';

-- ============================================================
-- 7. ALTER TABLE TASKS
-- ============================================================

-- Q4.1 Rename a Column
-- Objective: Rename patients.phone to patients.phone_number.
ALTER TABLE patients
RENAME COLUMN phone TO phone_number;

-- Verify
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'patients'
ORDER BY ordinal_position;

-- Q4.2 Change a Column Data Type
-- Objective: Change patients.age from INTEGER to SMALLINT.
ALTER TABLE patients
ALTER COLUMN age TYPE SMALLINT
USING age::SMALLINT;

-- Verify
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'patients'
  AND column_name = 'age';

-- Q4.3 Add a Column
-- Objective: Add an email column to store patient email addresses.
ALTER TABLE patients
ADD COLUMN email VARCHAR(120);

-- Verify
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'patients'
ORDER BY ordinal_position;

-- ============================================================
-- 8. ADDITIONAL INSERT TASKS
-- ============================================================

-- Q5.1 Insert a Single Record
-- Objective: Add one new patient.
INSERT INTO patients (full_name, age, gender, phone_number, email)
VALUES ('Frank Tuyisenge', 29, 'Male', '0781000006', 'frank@example.com');

-- Verify
SELECT *
FROM patients
WHERE phone_number = '0781000006';

-- Q5.2 Insert Multiple Records
-- Objective: Add several new doctors.
INSERT INTO doctors (doctor_name, specialty, phone) VALUES
('Dr. Samuel Hakizimana', 'Neurology', '0782000006'),
('Dr. Olive Uwamwezi', 'Gynecology', '0782000007'),
('Dr. Michael Karekezi', 'ENT', '0782000008');

-- Verify
SELECT *
FROM doctors
WHERE phone IN ('0782000006', '0782000007', '0782000008');

-- Q5.3 Insert a Related Record
-- Objective: Add a visit using valid foreign keys from existing parent tables.
INSERT INTO visits (patient_id, doctor_id, visit_date, diagnosis)
VALUES (
    (SELECT patient_id FROM patients WHERE phone_number = '0781000006'),
    (SELECT doctor_id FROM doctors WHERE phone = '0782000006'),
    '2026-10-24',
    'Headache'
);

-- Verify the related record
SELECT
    v.visit_id,
    p.full_name AS patient_name,
    d.doctor_name,
    v.visit_date,
    v.diagnosis
FROM visits AS v
JOIN patients AS p ON v.patient_id = p.patient_id
JOIN doctors AS d ON v.doctor_id = d.doctor_id
WHERE p.phone_number = '0781000006';

-- ============================================================
-- FINAL CHECKS
-- ============================================================

SELECT COUNT(*) AS patient_count FROM patients;
SELECT COUNT(*) AS doctor_count FROM doctors;
SELECT COUNT(*) AS visit_count FROM visits;

-- Final multi-table report
SELECT
    p.full_name AS patient_name,
    d.doctor_name,
    d.specialty,
    v.visit_date,
    v.diagnosis
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
JOIN doctors d ON v.doctor_id = d.doctor_id
ORDER BY v.visit_date, p.full_name;
