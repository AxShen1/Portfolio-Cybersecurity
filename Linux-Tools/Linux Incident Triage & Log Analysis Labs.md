# 🐧 Linux Incident Triage & Log Analysis Labs

![Linux](https://img.shields.io/badge/OS-Debian%20Linux-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![Focus](https://img.shields.io/badge/Focus-Incident%20Response%20%26%20Log%20Analysis-00599C?style=for-the-badge&logo=linux&logoColor=white)
![Course](https://img.shields.io/badge/Certificate-Google%20Cybersecurity-4285F4?style=for-the-badge&logo=google&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

Dokumentacja laboratoryjna oraz zestawienie praktycznych procedur analizy incydentów i filtrowania logów w środowisku **Debian Linux (CLI/Headless)**, zrealizowane na potrzeby profilu SOC / Security Analyst.

---

## 📋 Table of Contents

- [Scenario Overview](#-scenario-overview)
- [Key Findings & Executive Summary](#-key-findings--executive-summary)
- [Incident Response Methodology](#-incident-response-methodology)
- [Linux Log Analysis & Command Reference](#-linux-log-analysis--command-reference)
  - [1. Environment & Navigation](#1-environment--navigation)
  - [2. Package Management (APT)](#2-package-management-apt)
  - [3. Log Filtering & Pattern Matching (`grep` & Pipes)](#3-log-filtering--pattern-matching-grep--pipes)
  - [4. File System Hygiene & CLI Editing](#4-file-system-hygiene--cli-editing)
- [Evidence Integrity & Forensics](#-evidence-integrity--forensics)
- [Containment & Remediation Plan](#-containment--remediation-plan)
- [Author & Acknowledgments](#-author--acknowledgments)

---

## 🎯 Scenario Overview

Symulacja badania incydentu bezpieczeństwa na produkcyjnym serwerze Linux. Celem laboratorium było przeprowadzenie rozpoznania środowiska (triage), audyt struktury katalogów `/home/analyst`, weryfikacja autoryzacji nowo dodanych kont użytkowników (działy IT oraz HR) w plikach raportowych `/reports/users` oraz wyekstrahowanie pierwszych wektorów błędów z dziennika `/logs/server_logs.txt`.

---

## 🔑 Key Findings & Executive Summary

* **Rogue Account Detected:** W pliku `Q1_added_users.txt` zidentyfikowano konto `temp_admin_it`, które nie posiada odpowiedniego zgłoszenia w systemie Change Management.
* **Authentication Anomaly:** Pierwsze wiersze logu `server_logs.txt` wykazały wielokrotne komunikaty `[WARNING]` oraz nieudane próby logowania z adresu IP `192.168.1.105`.
* **Privilege Scope:** Konto analityka posiadało poprawny dostęp odczytu do analizy raportów i korelacji tożsamości.

---

## ⚙️ Incident Response Methodology

```
+------------------------+      +--------------------------+      +-------------------------+
|  1. Reconnaissance     | ---> |  2. Access & Identity    | ---> |  3. Log Inspection      |
|  (pwd, ls -la)         |      |  (Q1_added_users.txt)    |      |  (head, tail, grep)     |
+------------------------+      +--------------------------+      +-------------------------+
                                                                               |
+------------------------+      +--------------------------+                   v
|  5. Containment        | <--- |  4. Evidence Integrity   | <-----------------+
|  (usermod, iptables)   |      |  (sha256sum verification)|
+------------------------+      +--------------------------+
```

---

## 🛠️ Linux Log Analysis & Command Reference

### 1. Environment & Navigation

| Command | Syntax Example | Analytical Purpose |
| :--- | :--- | :--- |
| `pwd` | `pwd` | Potwierdzenie bieżącej ścieżki w drzewie katalogów |
| `ls` | `ls -la /home/analyst` | Wylistowanie wszystkich plików (w tym ukrytych `.` i `..`) wraz z uprawnieniami POSIX |
| `cat` | `cat reports/users/Q1_added_users.txt` | Odczyt zawartości pliku raportu |
| `head` | `head -n 10 server_logs.txt` | Podgląd pierwszych $N$ wierszy logu w celu weryfikacji nagłówka i znacznika czasu |
| `tail` | `tail -n 20 server_logs.txt` | Podgląd ostatnich $N$ wierszy w celu oceny najnowszych zdarzeń |

---

### 2. Package Management (APT)

Zarządzanie oprogramowaniem i narzędziami analitycznymi w systemie z wykorzystaniem `sudo`:

```bash
# Instalacja narzędzi analitycznych i do analizy ruchu sieciowego
sudo apt install tcpdump nload htop -y

# Weryfikacja zainstalowanego oprogramowania
apt list --installed | grep -i "tcpdump"

# Usuwanie nieużywanych pakietów w celu redukcji powierzchni ataku
sudo apt remove <package_name> -y
```

---

### 3. Log Filtering & Pattern Matching (`grep` & Pipes)

Wykorzystanie potoków (`|`) oraz narzedzia `grep` do szybkiej ekstrakcji anomalii:

```bash
# Wyszukiwanie błędów z uwzględnieniem wielkości liter
grep error server_logs.txt

# Wyszukiwanie bez uwzględniania wielkości liter (-i)
grep -i "warning" /logs/server_logs.txt

# Wyszukiwanie fraz ze spacjami
grep "Human Resources" Q4_added_users.txt

# Łączenie komend za pomocą potoku
ls reports/users | grep Q1
```

---

### 4. File System Hygiene & CLI Editing

Procedury utrzymania porządku w katalogach roboczych podczas badania incydentu:

```bash
# Tworzenie katalogów na logi i raporty
mkdir -p /home/analyst/logs

# Przenoszenie raportów do właściwych ścieżek
mv notes/Q3patches.txt reports/

# Tworzenie i edycja notatek z dochodzenia
touch notes/tasks.txt
nano notes/tasks.txt

# Bezpieczne czyszczenie plików tymczasowych
rm notes/tempnotes.txt
rm -r temp_directory/
```

---

## 🔒 Evidence Integrity & Forensics

Zabezpieczenie materiału dowodowego za pomocą kryptograficznych sum kontrolnych (Chain of Custody):

```bash
# Generowanie sumy kontrolnej SHA-256 dla badanych plików
sha256sum /reports/users/Q1_added_users.txt > /reports/users/Q1_added_users.txt.sha256
sha256sum /logs/server_logs.txt > /logs/server_logs.txt.sha256

# Weryfikacja spójności pliku w przyszłości
sha256sum -c /logs/server_logs.txt.sha256
```

---

## 🛡️ Containment & Remediation Plan

1. **Isolation of Unauthorized Account:**
   ```bash
   sudo usermod -s /sbin/nologin temp_admin_it
   sudo passwd -l temp_admin_it
   ```

2. **Network Blocking (Threat IP):**
   ```bash
   sudo iptables -A INPUT -s 192.168.1.105 -j DROP
   ```

3. **SIEM Ingestion:**
   Przekazanie zweryfikowanych plików logów do centralnego systemu SIEM w celu korelacji zdarzeń.

---

## 👤 Author & Acknowledgments

* **Notes & Labs:** Zrealizowane na podstawie materiałów z kursu **Google Cybersecurity Certificate**.
* **Repository Owner:** Security Analyst Portfolio Project.