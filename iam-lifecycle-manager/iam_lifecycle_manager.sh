#!/usr/bin/env bash
# ==============================================================================
# Script: iam_lifecycle_manager.sh
# Purpose: Walk through a Linux user lifecycle (onboard -> delegate -> expand
#          -> offboard) using useradd/usermod/chown/userdel.
#
# SAFE BY DEFAULT: without --apply it only PRINTS the commands (dry run).
# With --apply it really creates and deletes an account, so use a throw-away
# lab VM/container, never a real system.
#
# Usage:  ./iam_lifecycle_manager.sh            # dry run
#         sudo ./iam_lifecycle_manager.sh --apply
# ==============================================================================
set -euo pipefail

TARGET_USER="researcher9"
PRIMARY_GROUP="research_team"
SEC_GROUP="sales_team"
PROJECT_FILE="/home/researcher2/projects/project_r.txt"

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

if [ "$APPLY" -eq 1 ] && [ "$(id -u)" -ne 0 ]; then
    echo "[!] --apply needs root (run with sudo)." >&2
    exit 1
fi

run() {
    if [ "$APPLY" -eq 1 ]; then
        echo "    + $*"
        "$@"
    else
        echo "    (dry run) $*"
    fi
}

echo "=========================================================="
echo "   LINUX IAM LIFECYCLE  [mode: $([ $APPLY -eq 1 ] && echo APPLY || echo DRY RUN)]"
echo "=========================================================="

if [ "$APPLY" -eq 1 ]; then
    for g in "$PRIMARY_GROUP" "$SEC_GROUP"; do
        getent group "$g" >/dev/null || { echo "[!] Group $g does not exist. Create it first (groupadd $g)." >&2; exit 1; }
    done
    if id "$TARGET_USER" >/dev/null 2>&1; then
        echo "[!] User $TARGET_USER already exists. Aborting." >&2; exit 1
    fi
fi

echo "[*] PHASE 1: Onboarding"
run useradd "$TARGET_USER"
run usermod -g "$PRIMARY_GROUP" "$TARGET_USER"

echo "[*] PHASE 2: Asset delegation (ownership transfer)"
if [ "$APPLY" -eq 0 ] || [ -f "$PROJECT_FILE" ]; then
    run chown "$TARGET_USER" "$PROJECT_FILE"
else
    echo "    [skip] $PROJECT_FILE not found"
fi

echo "[*] PHASE 3: Role expansion (add supplementary group, keep existing ones)"
run usermod -aG "$SEC_GROUP" "$TARGET_USER"

echo "[*] PHASE 4: Offboarding"
# Note: files still owned by the user become orphaned (numeric UID only).
# Re-assign or archive them BEFORE deleting an account in real life.
run userdel "$TARGET_USER"
# useradd created a personal group; because the primary group was changed in
# phase 1, userdel leaves it behind, so remove it to avoid an orphaned group.
if [ "$APPLY" -eq 0 ] || getent group "$TARGET_USER" >/dev/null; then
    run groupdel "$TARGET_USER"
fi

if [ "$APPLY" -eq 1 ]; then
    echo "[+] Lifecycle completed."
else
    echo "[+] Dry run completed (nothing was changed)."
fi
