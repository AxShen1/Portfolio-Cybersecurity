#!/bin/bash
# ==============================================================================
# Script: audit_tool.sh
# Purpose: Automated Server Log Error Extraction & IAM User Lifecycle Audit
# ==============================================================================

LOG_DIR="./logs"
USER_DIR="./reports/users"

echo "=================================================="
echo "         SOC AUTOMATED LOG & IAM AUDIT           "
echo "=================================================="

# 1. Zadanie 1 - Analiza błędów w logach serwera
echo "[*] Step 1: Scanning server logs for errors..."
if [ -f "$LOG_DIR/server_logs.txt" ]; then
    ERROR_COUNT=$(grep -i "error" "$LOG_DIR/server_logs.txt" | wc -l)
    echo "    Found $ERROR_COUNT error entries in server_logs.txt."
    echo "    Sample error preview:"
    grep -i "error" "$LOG_DIR/server_logs.txt" | head -n 3
else
    echo "    [!] server_logs.txt not found."
fi

echo ""
# 2. Zadanie 2 - Wyszukiwanie raportów kwartalnych za pomocą potoków 
echo "[*] Step 2: Locating quarterly user audit reports (Piping: ls | grep)..."
if [ -d "$USER_DIR" ]; then
    Q1_REPORTS=$(ls "$USER_DIR" | grep "Q1" | wc -l)
    ACCESS_REPORTS=$(ls "$USER_DIR" | grep "access" | wc -l)
    echo "    Q1-related reports found: $Q1_REPORTS"
    echo "    Access-related reports found: $ACCESS_REPORTS"
fi

echo ""
# 3. Zadanie 3 - Weryfikacja cyklu życia tożsamości / IAM 
echo "[*] Step 3: Verifying targeted IAM changes..."
TARGET_USER="jhill"
if [ -f "$USER_DIR/Q2_deleted_users.txt" ]; then
    if grep -q "$TARGET_USER" "$USER_DIR/Q2_deleted_users.txt"; then
        echo "    [CONFIRMED] User '$TARGET_USER' was successfully deleted in Q2."
    fi
fi

TARGET_DEPT="Human Resources"
if [ -f "$USER_DIR/Q4_added_users.txt" ]; then
    HR_COUNT=$(grep "$TARGET_DEPT" "$USER_DIR/Q4_added_users.txt" | wc -l)
    echo "    New users provisioned in '$TARGET_DEPT' (Q4): $HR_COUNT"
fi

echo "=================================================="
echo "[+] Audit completed successfully."
