# 🛡️ SOC SQL Playbook – Alert Tuning, Timeline Reconstruction & Threat Correlation

[![Language: SQL](https://img.shields.io/badge/Language-SQL-blue.svg)](#)
[![DBMS: MariaDB / MySQL](https://img.shields.io/badge/DBMS-MariaDB%20%2F%20MySQL-orange.svg)](#)
[![Role: SOC L1](https://img.shields.io/badge/Role-SOC%20Analyst-red.svg)](#)

## 📌 Overview
A set of ready-to-use SQL queries for SOC (L1) analysts, covering alert triage, incident reconstruction, asset management and threat hunting I did for my Cybersecurity Certificate. The scripts are compatible with **MariaDB / MySQL** and can serve as templates for SIEM / SOAR systems that support SQL-like syntax.

## 🗄️ Data Model
| Table | Key columns |
|---|---|
| `log_in_attempts` | `event_id`, `username`, `login_date`, `login_time`, `country`, `success` (1/0) |
| `employees` | `employee_id`, `device_id`, `username`, `department`, `office` |
| `machines` | `device_id`, `operating_system`, `OS_patch_date` |

Shared keys: `employees.device_id = machines.device_id` and `employees.username = log_in_attempts.username`.

## 📚 Playbook Contents

### 1. SIEM Alert Tuning (`AND`, `OR`, `NOT`, `LIKE`)
Single indicators (e.g. a failed login) generate thousands of false positives (*alert fatigue*). Combining conditions makes detection more precise.
- **Time-based correlation:** `success = 0 AND login_time > '18:00:00'` – night-time attacks on accounts.
- **Geofencing:** `NOT country LIKE 'MEX%'` – excludes legitimate traffic (`MEX`, `MEXICO` variants) and exposes foreign logins.
- **Physical-logical scoping:** department + building segment (`department = 'Marketing' AND office LIKE 'East%'`).
- **Policy exclusions:** skipping the IT department during mass updates (patch management).
- **High-risk departments:** `Finance OR Sales` (phishing, compliance/GRC training).

### 2. Timeline Reconstruction (Time-Series Filtering)
- **Incident window isolation:** `login_date BETWEEN X AND Y` – freezes the time window for forensics.
- **Pre-business-hours triage:** `login_time BETWEEN '06:00:00' AND '07:00:00'` or `< '07:00:00'` – credential stuffing and insider activity.
- **Event correlation:** `event_id BETWEEN 100 AND 150` – correlation with IDS/IPS.

### 3. Asset Management & Incident Scoping
- **Targeted vulnerability patching:** isolating machines with a vulnerable OS (`operating_system = 'OS 2'`).
- **Incident scoping:** from a single office (`South-109`) to a whole zone (`LIKE 'South%'`) – the basis for containment.

### 4. Threat Hunting & Vulnerability Audit
- **OS patch auditing:** `device_id`, `operating_system`, `OS_patch_date`.
- **Geographic anomaly detection:** checking login country (Impossible Travel / Foreign Login).
- **Chronological triage:** `ORDER BY login_date, login_time` – quickly surfaces off-hours activity.

### 5. Data Correlation & Enrichment (`JOIN`)
Raw logs are useless without business context – detection systems work with `device_id` and `username`, while incident response needs identity and department.
- **Threat attribution (`INNER JOIN`):** logins + employee data (e.g. an attack aimed at the Finance department).
- **Rogue asset detection (`LEFT JOIN`):** machines with no assigned owner (`NULL`) = an inventory gap.
- **`table.column` notation:** removes ambiguity when joining on shared keys.

## 🚀 Usage
```bash
mysql -u <user> -p <database_name> < soc_sql_playbook.sql
```
Queries can also be run one at a time in the `mysql` console or in a SIEM tool with SQL support.

```
