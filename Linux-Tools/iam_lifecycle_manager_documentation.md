# 👥 Linux IAM & User Lifecycle Automation

[![Category: Identity Management](https://img.shields.io/badge/Category-IAM%20%26%20RBAC-blue.svg)](#)
[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI%20%2F%20Bash-orange.svg)](#)

## 📌 Project Overview
Właściwe zarządzanie cyklem życia tożsamości (Identity Lifecycle Management) zapobiega powstawaniu tzw. kont widm (osieroconych kont), które są częstym wektorem ataków w systemach serwerowych.

Skrypt `iam_lifecycle_manager.sh` automatyzuje cztery krytyczne fazy zarządzania pracownikiem w systemie Linux w oparciu o zasadę Role-Based Access Control (RBAC).

## 🔄 Lifecycle Phases Simulated
1. **Onboarding (Provisioning):** Bezpieczne utworzenie konta (`useradd`) i natychmiastowe przypisanie użytkownika do docelowej grupy podstawowej (`usermod -g`).
2. **Asset Delegation:** Zmiana właściciela plików projektowych (`chown`), gwarantująca nowemu pracownikowi ciągłość działania bez używania konta root.
3. **Role Expansion:** Przypisywanie dostępu do grup dodatkowych bez nadpisywania uprawnień bazowych (`usermod -aG`).
4. **Secure Offboarding (Deprovisioning):** Całkowite usunięcie użytkownika z systemu (`userdel`) wraz ze sprzątaniem osieroconych grup osobistych (`groupdel`), co chroni przed błędami w późniejszym mapowaniu GID (Group ID).

## 🚀 Execution
```bash
chmod +x iam_lifecycle_manager.sh
sudo ./iam_lifecycle_manager.sh