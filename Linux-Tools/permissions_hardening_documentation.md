# 🔒 Linux DAC Access Control Hardening & Least Privilege Engine

[![Security: POSIX DAC](https://img.shields.io/badge/Security-POSIX%20DAC-red.svg)](#)
[![Concept: Principle of Least Privilege](https://img.shields.io/badge/Concept-PoLP%20Enforcement-blue.svg)](#)
[![Compliance: ISO 27001](https://img.shields.io/badge/Compliance-ISO%2FIEC%2027001%20A.8.2-green.svg)](#)
[![Framework: NIST SP 800-53](https://img.shields.io/badge/Framework-NIST%20AC--6-orange.svg)](#)



---

## 📋 Table of Contents
* [Project Overview](#-project-overview)
* [Scenario & Environment Context](#-scenario--environment-context)
* [Remediation Matrix](#-remediation-matrix)
* [Step-by-Step Security Analysis](#-step-by-step-security-analysis)
* [Core Architectural & Security Concepts](#-core-architectural--security-concepts)
* [Compliance & Standards Mapping](#-compliance--standards-mapping)
* [How to Execute](#-how-to-execute)

---

## 📌 Project Overview

Zadanie obejmowało błędnie skonfigurowane bity uprawnień do plików i katalogów w systemach uniksowych stanowią krytyczny wektor nieautoryzowanego ujawnienia danych (*Information Disclosure*) oraz eskalacji uprawnień (*Privilege Escalation*). 

Projekt obejmuje:
1. Audyt struktury projektowej w katalogu `/home/researcher2/projects`.
2. Identyfikację plików z nadmiarowymi uprawnieniami zapisu/odczytu dla użytkowników spoza grupy właścicieli.
3. Automatyczne utwardzenie (*hardening*) uprawnień za pomocą skryptu Bash `harden_permissions.sh`.

---

## 🧪 Scenario & Environment Context

* **User:** `researcher2`
* **Primary Group:** `research_team`
* **Target Directory:** `/home/researcher2/projects`
* **Objective:** Wyeliminowanie nieautoryzowanego dostępu dla podmiotów ze sfery `group` oraz `other` z zachowaniem ciągłości prac analitycznych.

---

## 🛡️ Remediation Matrix

| Obiekt | Uprawnienia Pierwotne | Ryzyko / Luka Bezpieczeństwa | Stan Po Utwardzeniu | Zastosowana Komenda |
| :--- | :--- | :--- | :--- | :--- |
| `project_k.txt` | `-rw-rw-rw-` | **World-Writable:** Dowolny użytkownik w systemie mógł zmodyfikować lub usunąć zawartość. | `-rw-rw-r--` | `chmod o-w project_k.txt` |
| `project_m.txt` | `-rw-r-----` | **Information Disclosure:** Członkowie grupy `research_team` posiadali nieuprawniony wgląd do pliku poufnego. | `-rw-------` | `chmod g-rw,o-rwx project_m.txt` |
| `.project_x.txt` *(ukryty)* | `-rw-rw----` | **Integrity Violation:** Archiwalny plik nie powinien być modyfikowany przez użytkownika ani grupę. | `-r--r-----` | `chmod ug-w .project_x.txt` |
| `drafts/` *(katalog)* | `drwx--x---` | **Directory Traversal:** Grupa posiadała bit `x`, co pozwalało na wchodzenie do katalogu roboczego i odpytywanie zawartości. | `drwx------` | `chmod g-x drafts` |

---

## 🔍 Step-by-Step Security Analysis

### Task 1: Environment & File Permission Inspection
Wstępne odpytanie metadanych plików w katalogu roboczym za pomocą flagi `ls -la` (uwzględniającej pliki ukryte rozpoczynające się od kropki `.`):

```bash
researcher2@sec-server:~/projects$ ls -la
total 20
drwx--x--- 2 researcher2 research_team 4096 Oct 14 18:40 drafts
-rw-rw-rw- 1 researcher2 research_team   46 Oct 14 18:40 project_k.txt
-rw-r----- 1 researcher2 research_team   46 Oct 14 18:40 project_m.txt
-rw-rw-r-- 1 researcher2 research_team   46 Oct 14 18:40 project_r.txt
-rw-rw-r-- 1 researcher2 research_team   46 Oct 14 18:40 project_t.txt
-rw-rw---- 1 researcher2 research_team   46 Oct 14 18:40 .project_x.txt
```

### Task 2: Publicly Writable File & Sensitive Data Hardening
* **World-Writable Remediation:** Plik `project_k.txt` miał otwarty bit zapisu dla podmiotu `other` ($o+w$). Usunięcie bitu zapisu zablokowało możliwość nieautoryzowanej modyfikacji.
* **Confidential Asset Isolation:** Plik `project_m.txt` zawierał dane zastrzeżone wyłącznie dla właściciela (`researcher2`). Odebrano grupie prawo odczytu ($g-r$).

### Task 3: Hidden Archive File Integrity Protection
Plik `.project_x.txt` to archiwalny zasób ukryty. Zgodnie z polityką retro-retencji, zasób ten powinien pozostać w trybie tylko do odczytu (*Read-Only*) zarówno dla właściciela, jak i dla grupy ($ug-w$).

### Task 4: Directory Traversal Mitigation
Katalog `/home/researcher2/projects/drafts` posiadał uprawnienia `drwx--x---`. Obecność bitu `x` przyznawała grupie prawo do przechodzenia do katalogu (`cd drafts`) i operowania na znajdujących się tam zasobach. Usunięcie bitu $g-x$ ograniczyło dostęp wyłącznie do użytkownika `researcher2`.

---

## 🔑 Core Architectural & Security Concepts

1. **Znaczenie Bitu Wykonania (`x`) na Katalogach:**
   * Na plikach zwykłych bit `x` oznacza możliwość uruchomienia programu/skryptu.
   * Na katalogach bit `x` oznacza prawo do **przeszukiwania/przechodzenia (Directory Traversal)**. Brak bitu `x` uniemożliwia przejście do katalogu poleceniem `cd` oraz odczytanie metadanych zawartych w nim plików.
2. **UGO Access Control Model:**
   * **User ($u$):** Właściciel pliku.
   * **Group ($g$):** Użytkownicy przypisani do grupy właściciela.
   * **Other ($o$):** Wszyscy pozostali użytkownicy w systemie.
3. **Ukryte wektory danych (Dotfiles):**
   * Pliki rozpoczynające się od kropki (np. `.project_x.txt`) nie są widoczne podczas wykonywania standardowego `ls`. W procedurach audytowych niewykonanie `ls -la` stwarza ryzyko przeoczenia ukrytych skryptów lub konfiguracji.

---

## 📜 Compliance & Standards Mapping

* **NIST SP 800-53 (Control AC-6 - Least Privilege):** Wdrożone zmiany ograniczają uprawnienia procesów i użytkowników do absolutnego minimum niezbędnego do wykonywania zadań służbowych.
* **ISO/IEC 27001 (Control A.8.2 - Privileged Access Rights):** Ograniczenie dostępu do poufnych plików projektu i eliminacja nieautoryzowanych uprawnień zapisu zapobiega naruszeniu spójności oraz poufności informacji.

---

## 🚀 How to Execute

```bash
# 1. Nadanie uprawnień do wykonania skryptu hardeningu
chmod +x harden_permissions.sh

# 2. Uruchomienie automatycznego audytu i korekty uprawnień
./harden_permissions.sh

# Opcjonalnie: Uruchomienie na niestandardowej ścieżce
./harden_permissions.sh /custom/path/to/projects
```
