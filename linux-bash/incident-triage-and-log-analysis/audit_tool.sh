#!/usr/bin/env bash
# ==============================================================================
# Script: audit_tool.sh
# Purpose: Count errors in a server log and verify IAM changes in quarterly
#          user reports (training lab, read-only: it never modifies files).
# Usage:   ./audit_tool.sh [base_dir]      (default: current directory)
#          Expects: <base>/logs/server_logs.txt and <base>/reports/users/*.txt
# ==============================================================================
set -u

BASE_DIR="${1:-.}"
LOG_DIR="$BASE_DIR/logs"
USER_DIR="$BASE_DIR/reports/users"

echo "=================================================="
echo "         LOG & IAM AUDIT (read-only)"
echo "=================================================="

# Step 1 - count error entries in the server log
echo "[*] Step 1: Scanning server log for errors..."
if [ -f "$LOG_DIR/server_logs.txt" ]; then
    ERROR_COUNT=$(grep -ci "error" "$LOG_DIR/server_logs.txt" || true)
    echo "    Found $ERROR_COUNT error entries in server_logs.txt."
    echo "    Sample error preview:"
    grep -i "error" "$LOG_DIR/server_logs.txt" | head -n 3
else
    echo "    [!] $LOG_DIR/server_logs.txt not found."
fi

echo ""
# Step 2 - find quarterly reports with a pipe (ls | grep)
echo "[*] Step 2: Locating quarterly user reports (pipe: ls | grep)..."
if [ -d "$USER_DIR" ]; then
    Q1_REPORTS=$(ls "$USER_DIR" | grep -c "Q1" || true)
    ACCESS_REPORTS=$(ls "$USER_DIR" | grep -c "access" || true)
    echo "    Q1-related reports found: $Q1_REPORTS"
    echo "    Access-related reports found: $ACCESS_REPORTS"
else
    echo "    [!] $USER_DIR not found."
fi

echo ""
# Step 3 - verify identity lifecycle changes
echo "[*] Step 3: Verifying targeted IAM changes..."
TARGET_USER="jhill"
if [ -f "$USER_DIR/Q2_deleted_users.txt" ]; then
    if grep -q "$TARGET_USER" "$USER_DIR/Q2_deleted_users.txt"; then
        echo "    [CONFIRMED] User '$TARGET_USER' appears in the Q2 deleted-users report."
    else
        echo "    [NOT FOUND] User '$TARGET_USER' is not in the Q2 deleted-users report."
    fi
fi

TARGET_DEPT="Human Resources"
if [ -f "$USER_DIR/Q4_added_users.txt" ]; then
    HR_COUNT=$(grep -c "$TARGET_DEPT" "$USER_DIR/Q4_added_users.txt" || true)
    echo "    Users added in '$TARGET_DEPT' (Q4 report): $HR_COUNT"
fi

echo "=================================================="
echo "[+] Audit finished."
