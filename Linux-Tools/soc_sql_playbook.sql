-- ==============================================================================
-- SOC SQL Playbook: Alert Tuning, Timeline Reconstruction, Asset Scoping,
--                   Threat Hunting & Data Correlation
-- DBMS: MariaDB / MySQL
-- Tables: log_in_attempts, employees, machines (columns described in soc_sql_documentation.md)
-- ==============================================================================


-- ##############################################################################
-- PART 1: SIEM ALERT TUNING (Boolean Logic: AND / OR / NOT / LIKE)
-- ##############################################################################

-- 1.1 Event correlation (Brute Force / Credential Stuffing)
-- Goal: A failed login alone is noise. A failed login after business hours
-- (after 18:00) is a strong indicator of a targeted attack (IoC).
-- Note: Boolean values in SQL are stored as 1 (TRUE) and 0 (FALSE).
SELECT *
FROM log_in_attempts
WHERE login_time > '18:00:00' AND success = 0;

-- 1.2 Geofencing (logins from unauthorized countries)
-- Goal: The company operates in Mexico. Filter out legitimate traffic (MEX, MEXICO)
-- to leave only attempts from other countries (e.g. Impossible Travel).
SELECT *
FROM log_in_attempts
WHERE NOT country LIKE 'MEX%';

-- 1.3 Narrowing an incident to critical assets (Targeted Scoping)
-- Goal: Marketing employees physically located in the East building.
SELECT *
FROM employees
WHERE department = 'Marketing' AND office LIKE 'East%';

-- 1.4 Business exclusions (False Positive Reduction)
-- Goal: List of hosts for a mass update, excluding the IT department,
-- which has its own patch cycle.
SELECT *
FROM employees
WHERE NOT department = 'Information Technology';

-- 1.5 High-risk departments (e.g. phishing attacks, compliance/GRC training)
SELECT *
FROM employees
WHERE department = 'Finance' OR department = 'Sales';


-- ##############################################################################
-- PART 2: TIMELINE RECONSTRUCTION (Time-Series Filtering)
-- ##############################################################################

-- 2.1 Incident window isolation (Date Range Triage) - critical 72-hour window
SELECT *
FROM log_in_attempts
WHERE login_date BETWEEN '2022-05-09' AND '2022-05-11';

-- 2.2 Pre-business-hours activity
-- Classic IoC for stolen credentials / automated scripts.

-- Narrow early-morning window
SELECT *
FROM log_in_attempts
WHERE login_time BETWEEN '06:00:00' AND '07:00:00';

-- Broad variant: all logins before the office opens
SELECT *
FROM log_in_attempts
WHERE login_time < '07:00:00';

-- 2.3 Filtering by Event ID (correlation with IDS/IPS, manual verification)
SELECT event_id, username, login_date
FROM log_in_attempts
WHERE event_id BETWEEN 100 AND 150;


-- ##############################################################################
-- PART 3: ASSET MANAGEMENT & INCIDENT SCOPING
-- ##############################################################################

-- 3.1 Identifying vulnerable machines (Vulnerability Management)
-- Devices running the outdated 'OS 2' that need immediate patching.
SELECT device_id, operating_system
FROM machines
WHERE operating_system = 'OS 2';

-- 3.2 Incident scoping A: a specific office (South-109) - identify the device owner
SELECT *
FROM employees
WHERE office = 'South-109';

-- 3.3 Incident scoping B: the whole zone (South segment) - basis for containment
SELECT *
FROM employees
WHERE office LIKE 'South%';


-- ##############################################################################
-- PART 4: THREAT HUNTING & VULNERABILITY AUDIT
-- ##############################################################################

-- 4.1 Patch level audit (Patch Management)
SELECT device_id, operating_system, OS_patch_date
FROM machines;

-- 4.2 Geolocation anomalies (Impossible Travel / Foreign Login)
-- Manual review of logins from outside authorized regions.
SELECT event_id, country
FROM log_in_attempts;

-- 4.3 Chronological triage (Off-hours Activity)
-- Stolen credentials are often used at night (e.g. 3:00 AM) - multi-column
-- sorting makes such attempts easy to spot.
SELECT username, login_date, login_time
FROM log_in_attempts
ORDER BY login_date, login_time;


-- ##############################################################################
-- PART 5: DATA CORRELATION & ENRICHMENT (SQL JOIN)
-- ##############################################################################

-- 5.1 Device attribution (INNER JOIN)
-- Vulnerable laptops (machines) + owner contact (employees).
SELECT machines.device_id, machines.operating_system,
       employees.username, employees.department
FROM machines
INNER JOIN employees
ON machines.device_id = employees.device_id;

-- 5.2 Rogue asset detection (LEFT JOIN)
-- Keeps all machines; those without an owner return NULL in the employee columns.
SELECT machines.device_id, machines.OS_patch_date, employees.username
FROM machines
LEFT JOIN employees
ON machines.device_id = employees.device_id;
-- Only machines without an owner: add  WHERE employees.username IS NULL;

-- 5.3 Login attribution (Threat Attribution)
-- Which departments do the accounts with (failed) logins belong to?
SELECT log_in_attempts.login_date, log_in_attempts.success,
       employees.username, employees.department
FROM employees
INNER JOIN log_in_attempts
ON employees.username = log_in_attempts.username;
