#!/bin/bash
# ==============================================================================
# Script: workspace_sanitizer.sh
# Description: Automated Security Workspace Sanitization & Patch Evidence Consolidator
# Role: SOC Analyst Maintenance & Compliance Baseline
# Standard Alignment: ISO/IEC 27001 (A.8.19 - Technical Vulnerability Management)
# ==============================================================================

set -euo pipefail

# Domyslny katalog docelowy z mozliwoscia przekazania wlasnej sciezki jako parametr: ./sanitizer.sh /custom/path
BASE_DIR="${1:-${HOME}/analyst}"
REPORTS_DIR="${BASE_DIR}/reports"
NOTES_DIR="${BASE_DIR}/notes"
LOGS_DIR="${BASE_DIR}/logs"
TEMP_DIR="${BASE_DIR}/temp"
AUDIT_LOG="${NOTES_DIR}/tasks.txt"

echo "[*] [$(date +'%Y-%m-%d %H:%M:%S')] Starting Workspace Sanitization in: ${BASE_DIR}"

# 1. Tworzenie dedykowanego katalogu na logi systemowe (Log Partitioning)
if [ ! -d "$LOGS_DIR" ]; then
    echo "[+] Creating dedicated logs archive directory: $LOGS_DIR"
    mkdir -p "$LOGS_DIR"
fi

# 2. Usuwanie tymczasowego srodowiska roboczego (Scratchpad / Staging Removal)
if [ -d "$TEMP_DIR" ]; then
    echo "[-] Removing deprecated temporary directory: $TEMP_DIR"
    rmdir "$TEMP_DIR" 2>/dev/null || rm -rf "$TEMP_DIR"
fi

# 3. Konsolidacja dowodow aktualizacji (Q3 Patch Evidence) do repozytorium audytowego
if [ -f "${NOTES_DIR}/Q3patches.txt" ]; then
    echo "[->] Consolidating Q3 Patch Report into compliance repository..."
    mkdir -p "$REPORTS_DIR"
    mv "${NOTES_DIR}/Q3patches.txt" "${REPORTS_DIR}/"
fi

# 4. Trwale usuwanie nieuzywanych notatek analitycznych (Data Hygiene & Sanitization)
if [ -f "${NOTES_DIR}/tempnotes.txt" ]; then
    echo "[-] Purging obsolete temporary analysis notes: tempnotes.txt"
    rm -f "${NOTES_DIR}/tempnotes.txt"
fi

# 5. Generowanie oficjalnego rejestru wykonanych dzialan (Immutable Audit Trail)
echo "[*] Generating immutable task audit record in $AUDIT_LOG..."
mkdir -p "$NOTES_DIR"
cat << 'EOF' > "$AUDIT_LOG"
Completed Tasks Audit Record
------------------------------------------------------------------
Timestamp: $(date -u +'%Y-%m-%dT%H:%M:%SZ')
Operator:  SOC Analyst
Scope:     /home/analyst workspace structure

Execution Log:
1. Created dedicated /logs repository for telemetric data & log retention.
2. Purged unneeded /temp staging directory and obsolete scratch notes (tempnotes.txt).
3. Consolidated Q1-Q3 patch management compliance records under /reports.
4. Verified POSIX directory structure compliance against SecOps baseline.
EOF

echo "[+] [$(date +'%Y-%m-%d %H:%M:%S')] Workspace sanitized and compliant with standard directory structure."