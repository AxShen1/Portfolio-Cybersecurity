#!/bin/bash
# ==============================================================================
# Script: iam_lifecycle_manager.sh
# Purpose: Automated Linux Identity & Access Management (IAM) Lifecycle
# Concept: RBAC (Role-Based Access Control) & Secure Offboarding
# ==============================================================================

set -euo pipefail

TARGET_USER="researcher9"
PRIMARY_GROUP="research_team"
SEC_GROUP="sales_team"
PROJECT_FILE="/home/researcher2/projects/project_r.txt"

echo "=========================================================="
echo "      LINUX IAM & USER LIFECYCLE MANAGEMENT SCRIPT        "
echo "=========================================================="

# Faza 1: ONBOARDING (Tworzenie konta i RBAC)
echo "[*] PHASE 1: Employee Onboarding"
echo "    [-] Provisioning new account: $TARGET_USER"
sudo useradd "$TARGET_USER"

echo "    [-] Assigning primary group: $PRIMARY_GROUP"
sudo usermod -g "$PRIMARY_GROUP" "$TARGET_USER"

# Faza 2: ASSET TRANSFER (Przekazanie własności plików)
echo "[*] PHASE 2: Asset Delegation"
if [ -f "$PROJECT_FILE" ]; then
    echo "    [-] Transferring ownership of $PROJECT_FILE to $TARGET_USER"
    sudo chown "$TARGET_USER" "$PROJECT_FILE"
fi

# Faza 3: ROLE EXPANSION (Dodanie uprawnień przekrojowych)
echo "[*] PHASE 3: Role/Access Expansion"
echo "    [-] Appending supplementary group: $SEC_GROUP"
sudo usermod -aG "$SEC_GROUP" "$TARGET_USER"

# Faza 4: OFFBOARDING (Bezpieczne usuwanie tożsamości)
echo "[*] PHASE 4: Employee Offboarding (Deprovisioning)"
echo "    [-] Terminating account access for $TARGET_USER"
sudo userdel "$TARGET_USER"

echo "    [-] Cleaning up orphaned personal groups to prevent SID/GID reuse issues"
sudo groupdel "$TARGET_USER" 2>/dev/null || true

echo "[+] Lifecycle simulation completed successfully."