#!/usr/bin/env bash
# ==============================================================================
# Script: harden_permissions.sh
# Purpose: Remove excessive POSIX permissions from a lab project directory
#          (least privilege). Training lab: file names match the lab scenario.
# Usage:   ./harden_permissions.sh [target_dir]    (default: $HOME/projects)
# Note:    Changes permissions in place. Run it on a COPY or a lab VM.
# ==============================================================================
set -euo pipefail

TARGET_DIR="${1:-${HOME}/projects}"

echo "=========================================================="
echo "   LINUX PERMISSION AUDIT & HARDENING (least privilege)"
echo "=========================================================="

if [ ! -d "$TARGET_DIR" ]; then
    echo "[!] Target directory $TARGET_DIR does not exist. Aborting." >&2
    exit 1
fi
cd "$TARGET_DIR"

# Step 1 - world-writable file: remove write for "other"
echo "[*] Step 1: Removing world-writable permission..."
if [ -f project_k.txt ]; then
    echo "    [-] chmod o-w project_k.txt"
    chmod o-w project_k.txt
fi

# Step 2 - confidential file: owner-only access
# Starting mode in the lab was -rw-r----- (640), so removing group rw and all
# other access leaves -rw------- (600).
echo "[*] Step 2: Restricting confidential data to the owner..."
if [ -f project_m.txt ]; then
    echo "    [-] chmod g-rw,o-rwx project_m.txt   (result: 600 if it was 640)"
    chmod g-rw,o-rwx project_m.txt
fi

# Step 3 - hidden archive file: read-only for user and group
echo "[*] Step 3: Making the hidden archive file read-only..."
if [ -f .project_x.txt ]; then
    echo "    [-] chmod ug-w .project_x.txt"
    chmod ug-w .project_x.txt
fi

# Step 4 - directory: group must not be able to enter it
echo "[*] Step 4: Removing group execute (traverse) on drafts/ ..."
if [ -d drafts ]; then
    echo "    [-] chmod g-x drafts"
    chmod g-x drafts
fi

echo
echo "[+] Done. Current permissions:"
ls -la
