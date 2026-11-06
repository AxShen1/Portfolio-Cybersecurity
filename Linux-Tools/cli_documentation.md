# 🔎 Linux CLI Recon & Command Discovery Toolkit

[![Category: CLI Operations](https://img.shields.io/badge/Category-Operations%20%26%20Recon-blue.svg)](#)
[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI%20%2F%20Bash-orange.svg)](#)
[![Framework: SecOps Baseline](https://img.shields.io/badge/Framework-Verify%20Before%20Execute-green.svg)](#)


---

## 📋 Table of Contents
* [Project Overview](#-project-overview)
* [SecOps Operational Baseline](#-secops-operational-baseline)
* [Command Discovery & Mapping Matrix](#-command-discovery--mapping-matrix)
* [Script Architecture](#-script-architecture)
* [How to Execute](#-how-to-execute)

---

## 📌 Project Overview

Prace w środowisku produkcyjnym uruchomienie polecenia z nieznanymi lub błędnymi flagami stwarza bezpośrednie ryzyko uszkodzenia danych, nieplanowanego zatrzymania usług lub osłabienia mechanizmów kontroli dostępu.

Projekt realizuje podejście **"Verify Before You Execute"**:
1. **Szybka weryfikacja funkcji (`whatis`):** Pozwala natychmiast odróżnić destrukcyjne narzędzia od bezpiecznych (np. różnica między `rm` a `rmdir`).
2. **Inspekcja bezpiecznej składni (`man` + SYNOPSIS):** Wyciąga wycinek podręcznika z zasadami użycia i flagami (np. flaga `-e` w `useradd` do ustawiania wygasania kont).
3. **Wyszukiwanie według intencji (`apropos -a`):** Umożliwia znalezienie właściwej komendy na podstawie szukanej akcji, gdy nazwa binaru nie jest znana.

---

## 🛡️ SecOps Operational Baseline

> [!TIP]
> **Zasada bezpiecznego wykonania w SOC:** Nigdy nie uruchamiaj poleceń modyfikujących konta lub system plików bez wcześniejszej weryfikacji nagłówka SYNOPSIS w podręczniku systemowym.

---

## 📊 Command Discovery & Mapping Matrix

Poniższa tabela przedstawia wynik analizy laboratoryjnej i mapowanie komend pod kątem ich zastosowania operacyjnego:

| Szukana Funkcja / Intencja | Użyte Narzędzie Pomocy | Wykryta Komenda / Flaga | Zastosowanie Analityczne w SOC |
| :--- | :--- | :--- | :--- |
| Krótki opis działania `cat` | `whatis cat` | `cat` (*concatenate files*) | Odczyt niewielkich plików konfiguracyjnych i raportów. |
| Numerowanie linii w odczycie `cat` | `man cat` | `cat -n` / `--number` | Dokładna identyfikacja numerów linii w logach zdarzeń. |
| Wyszukanie komendy do odczytu początku pliku | `apropos -a first part file` | `head` | Szybki podgląd nagłówków i struktury znaczników czasu w logach. |
| Ustawienie daty wygasania konta tymczasowego | `man useradd` | `useradd -e <YYYY-MM-DD>` | Tworzenie kont tymczasowych. |
| Bezpieczne usuwanie wyłącznie **pustych** katalogów | `whatis rm rmdir` | `rmdir` | Czyszczenie katalogów roboczych bez ryzyka usunięcia plików. |
| Identyfikacja komendy do tworzenia nowych grup | `apropos -a create new group` | `groupadd` | Zarządzanie strukturą RBAC i tworzenie grup uprawnień. |

---

## ⚙️ Script Architecture

Skrypt ten `cli_recon_tool.sh` automatyzuje dwa główne tryby pracy:

1. **Tryb `verify`:**
   * Wywołuje `whatis` w celu pobrania 1-liniowego podsumowania.
   * Filtruje wyjście `man` i wyświetla wyłącznie sekcję **SYNOPSIS**, ograniczając natłok informacji.
2. **Tryb `search`:**
   * Wykorzystuje `apropos -a` do przefiltrowania stron podręcznika pod kątem zestawu słów kluczowych podanych w cudzysłowie.

---

## 🚀 How to Execute

```bash
# 1. Nadanie praw do wykonania
chmod +x cli_recon_tool.sh

# 2. Weryfikacja działania i składni polecenia useradd
./cli_recon_tool.sh verify useradd

# 3. Weryfikacja działania cat
./cli_recon_tool.sh verify cat

# 4. Wyszukanie narzędzia do tworzenia grup
./cli_recon_tool.sh search "create new group"

# 5. Wyszukanie narzędzia do wyświetlania początku pliku
./cli_recon_tool.sh search "first part file"