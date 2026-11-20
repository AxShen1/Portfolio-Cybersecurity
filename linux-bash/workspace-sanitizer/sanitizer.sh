#!/usr/bin/env bash
# ==============================================================================
# Script: sanitizer.sh
# Purpose: Tidy an analyst workspace: create logs/, remove an EMPTY temp/,
#          move Q3patches.txt into reports/, delete tempnotes.txt, and write a
#          record of what was actually done to notes/tasks.txt.
# Usage:   ./sanitizer.sh [base_dir]       (default: $HOME/analyst)
# ==============================================================================
set -euo pipefail

BASE_DIR="${1:-${HOME}/analyst}"
case "$BASE_DIR" in
    ""|"/"|"$HOME"|"$HOME/") echo "[!] Refusing to run on '$BASE_DIR'." >&2; exit 1 ;;
esac
[ -d "$BASE_DIR" ] || { echo "[!] $BASE_DIR is not a directory." >&2; exit 1; }

REPORTS_DIR="$BASE_DIR/reports"
NOTES_DIR="$BASE_DIR/notes"
LOGS_DIR="$BASE_DIR/logs"
TEMP_DIR="$BASE_DIR/temp"
AUDIT_LOG="$NOTES_DIR/tasks.txt"
ACTIONS=()          # what this run really did

now() { date -u +'%Y-%m-%dT%H:%M:%SZ'; }
echo "[*] $(now) Sanitizing workspace: $BASE_DIR"

# 1. Create a directory for logs
if [ ! -d "$LOGS_DIR" ]; then
    mkdir -p "$LOGS_DIR"
    ACTIONS+=("Created $LOGS_DIR")
fi

# 2. Remove temp/ only if it is empty (rmdir never deletes files)
if [ -d "$TEMP_DIR" ]; then
    if rmdir "$TEMP_DIR" 2>/dev/null; then
        ACTIONS+=("Removed empty directory $TEMP_DIR")
    else
        echo "[!] $TEMP_DIR is not empty; left in place. Review it manually."
    fi
fi

# 3. Move the Q3 patch report into reports/
if [ -f "$NOTES_DIR/Q3patches.txt" ]; then
    mkdir -p "$REPORTS_DIR"
    mv "$NOTES_DIR/Q3patches.txt" "$REPORTS_DIR/"
    ACTIONS+=("Moved Q3patches.txt to $REPORTS_DIR")
fi

# 4. Delete obsolete temporary notes
if [ -f "$NOTES_DIR/tempnotes.txt" ]; then
    rm -f "$NOTES_DIR/tempnotes.txt"
    ACTIONS+=("Deleted $NOTES_DIR/tempnotes.txt")
fi

# 5. Write a record of what was done (unquoted heredoc so $(...) is expanded)
mkdir -p "$NOTES_DIR"
{
    echo "Workspace Task Record"
    echo "---------------------"
    echo "Timestamp (UTC): $(now)"
    echo "Operator:        ${USER:-unknown}"
    echo "Workspace:       $BASE_DIR"
    echo
    echo "Actions performed:"
    if [ "${#ACTIONS[@]}" -eq 0 ]; then
        echo "  (none - workspace was already tidy)"
    else
        n=1; for a in "${ACTIONS[@]}"; do echo "  $n. $a"; n=$((n+1)); done
    fi
} > "$AUDIT_LOG"

echo "[+] Done. Record written to $AUDIT_LOG"
