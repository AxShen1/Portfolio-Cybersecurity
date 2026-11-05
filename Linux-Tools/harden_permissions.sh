#!/bin/bash
# ==============================================================================
# Script: harden_permissions.sh
# Purpose: POSIX Permissions Hardening & Least Privilege Enforcement
# Framework: NIST SP 800-53 (AC-6 Least Privilege) / ISO 27001 A.8.2
# ==============================================================================

set -euo pipefail

TARGET_DIR="${HOME}/projects"

echo "=========================================================="
echo "    LINUX ACCESS CONTROL AUDIT & HARDENING ENGINE         "
echo "=========================================================="

if [ ! -d "$TARGET_DIR" ]; then
    echo "[!] Target directory $TARGET_DIR does not exist. Aborting."
    exit 1
fi

cd "$TARGET_DIR"

# Zadanie 1 - Eliminacja podatności World-Writable
echo "[*] Step 1: Auditing and removing World-Writable permissions..."
if [ -f "project_k.txt" ]; then
    echo "    [-] Stripping write permission for 'others' on project_k.txt"
    chmod o-w project_k.txt
fi

# Zadanie 2 - Izolacja pliku poufnego 
echo "[*] Step 2: Restricting unauthorized group/other access to confidential data..."
if [ -f "project_m.txt" ]; then
    echo "    [-] Restricting project_m.txt to owner-only read/write (chmod 600)"
    chmod g-rw,o-rwx project_m.txt
fi

# Zadanie 3 - Zabezpieczenie ukrytych archiwów 
echo "[*] Step 3: Hardening hidden and archived assets..."
if [ -f ".project_x.txt" ]; then
    echo "    [-] Revoking write permissions for user and group on .project_x.txt"
    chmod ug-w .project_x.txt
fi

# Zadanie 4 - Blokada uprawnień przeszukiwania katalogu roboczego 
echo "[*] Step 4: Revoking group traversal execution on drafts directory..."
if [ -d "drafts" ]; then
    echo "    [-] Removing execute/traversal ('x') privilege for group on drafts/"
    chmod g-x drafts
fi

echo ""
echo "[+] Hardening complete. Current DAC status:"
ls -la "$TARGET_DIR"