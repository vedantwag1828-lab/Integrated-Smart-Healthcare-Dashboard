CREATE DATABASE healthcare_db;

USE healthcare_db;
CREATE TABLE Patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    address VARCHAR(255),
    registration_date DATE,
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    email VARCHAR(100)
);

desc patients;

CREATE TABLE Doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone_number VARCHAR(20),
    years_experience INT,
    hospital_branch VARCHAR(100),
    email VARCHAR(100)
);


CREATE TABLE Appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(100),
    status VARCHAR(30),

    FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id)
);

CREATE TABLE Treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10),
    treatment_type VARCHAR(100),
    description VARCHAR(255),
    cost DECIMAL(10,2),
    treatment_date DATE,

    FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
);

CREATE TABLE Billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    treatment_id VARCHAR(10),
    bill_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),

    FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id),

    FOREIGN KEY (treatment_id)
        REFERENCES Treatments(treatment_id)
);

SHOW TABLES;
-- Total No. of records

SELECT COUNT(*) AS patients FROM Patients;
SELECT COUNT(*) AS doctors FROM Doctors;
SELECT COUNT(*) AS appointments FROM Appointments;
SELECT COUNT(*) AS treatments FROM Treatments;
SELECT COUNT(*) AS billing FROM Billing;

-- Display all patients
SELECT * FROM Patients;

-- Display all doctors
SELECT * FROM Doctors;

-- Display all appointments
SELECT * FROM Appointments;

-- Display all treatments
SELECT * FROM Treatments;

-- Display all bills
SELECT * FROM Billing;

-- Display only the first five patients
SELECT * FROM Patients LIMIT 5;

-- Search for female patients (check actual gender values)
SELECT *
FROM Patients
WHERE gender = 'F';

-- Find doctors with more than 5 years of experience
SELECT *
FROM Doctors
WHERE years_experience > 5;

-- Find treatments costing more than 5000
SELECT *
FROM Treatments
WHERE cost > 4000;

-- Sort bills from highest to lowest amount
SELECT *
FROM Billing
ORDER BY amount DESC;

-- Total number of patients
SELECT COUNT(*) AS total_patients
FROM Patients;

-- Patients by gender
SELECT gender, COUNT(*) AS patient_count
FROM Patients
GROUP BY gender;

-- Patients by insurance provider
SELECT insurance_provider, COUNT(*) AS patient_count
FROM Patients
GROUP BY insurance_provider
ORDER BY patient_count DESC;

-- Total number of doctors
SELECT COUNT(*) AS total_doctors
FROM Doctors;

-- Average doctor experience
SELECT ROUND(AVG(years_experience), 2) AS average_experience
FROM Doctors;

-- Doctors by specialization
SELECT specialization, COUNT(*) AS doctor_count
FROM Doctors
GROUP BY specialization;

-- Appointments by status
SELECT status, COUNT(*) AS appointment_count
FROM Appointments
GROUP BY status;

-- Total treatment cost
SELECT ROUND(SUM(cost), 2) AS total_treatment_cost
FROM Treatments;

-- Average treatment cost
SELECT ROUND(AVG(cost), 2) AS average_treatment_cost
FROM Treatments;

-- Total billed amount
SELECT ROUND(SUM(amount), 2) AS total_billed_amount
FROM Billing;

-- Bills by payment status
SELECT payment_status, COUNT(*) AS bill_count
FROM Billing
GROUP BY payment_status;

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    a.appointment_id,
    a.appointment_date,
    a.reason_for_visit,
    a.status
FROM Patients p
JOIN Appointments a
    ON p.patient_id = a.patient_id;
    
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,
    a.appointment_id,
    a.appointment_date,
    a.status
FROM Doctors d
JOIN Appointments a
    ON d.doctor_id = a.doctor_id;
    
SELECT
    a.appointment_id,
    a.appointment_date,
    a.reason_for_visit,
    t.treatment_type,
    t.cost,
    t.treatment_date
FROM Appointments a
JOIN Treatments t
    ON a.appointment_id = t.appointment_id;
    
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    b.bill_id,
    b.bill_date,
    b.amount,
    b.payment_method,
    b.payment_status
FROM Patients p
JOIN Billing b
    ON p.patient_id = b.patient_id;

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status AS appointment_status,
    t.treatment_type,
    t.cost AS treatment_cost,
    b.amount AS bill_amount,
    b.payment_status
FROM Patients p
JOIN Appointments a
    ON p.patient_id = a.patient_id
JOIN Doctors d
    ON a.doctor_id = d.doctor_id
JOIN Treatments t
    ON a.appointment_id = t.appointment_id
LEFT JOIN Billing b
    ON t.treatment_id = b.treatment_id
    AND p.patient_id = b.patient_id;

-- Appointments by month
SELECT
    DATE_FORMAT(appointment_date, '%Y-%m') AS appointment_month,
    COUNT(*) AS total_appointments
FROM Appointments
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY appointment_month;

-- Patient registrations by month
SELECT
    DATE_FORMAT(registration_date, '%Y-%m') AS registration_month,
    COUNT(*) AS new_patients
FROM Patients
GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY registration_month;

-- Total treatment cost by treatment type
SELECT
    treatment_type,
    SUM(cost) AS total_cost,
    ROUND(AVG(cost), 2) AS average_cost
FROM Treatments
GROUP BY treatment_type
ORDER BY total_cost DESC;

-- Monthly billing totals
SELECT
    DATE_FORMAT(bill_date, '%Y-%m') AS bill_month,
    SUM(amount) AS total_billed
FROM Billing
GROUP BY DATE_FORMAT(bill_date, '%Y-%m')
ORDER BY bill_month;

CREATE OR REPLACE VIEW appointment_summary AS
SELECT
    a.appointment_id,
    a.appointment_date,
    a.status,
    a.reason_for_visit,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization
FROM Appointments a
JOIN Patients p
    ON a.patient_id = p.patient_id
JOIN Doctors d
    ON a.doctor_id = d.doctor_id;

SELECT * FROM appointment_summary;
















-- SET FOREIGN_KEY_CHECKS = 1;

-- USE healthcare_db;

-- SET FOREIGN_KEY_CHECKS = 0;
-- SELECT CURRENT_USER();
-- SHOW VARIABLES LIKE 'port';
-- SELECT VERSION();
-- drop database healthcare_db;

