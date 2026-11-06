#!/bin/bash
# ==============================================================================
# Script: cli_recon_tool.sh
# Purpose: SOC Command Reconnaissance & Safe Execution Verifier
# Core Tools: whatis, apropos, man
# ==============================================================================

set -euo pipefail

echo "=========================================================="
echo "      LINUX CLI RECON & SAFE DISCOVERY TOOLKIT            "
echo "=========================================================="

if [ "$#" -lt 2 ]; then
    echo "Usage Options:"
    echo "  ./cli_recon_tool.sh verify <command>   (Quickly verify what a command does)"
    echo "  ./cli_recon_tool.sh search <keywords> (Find a command based on action)"
    exit 1
fi

ACTION="$1"
shift

if [ "$ACTION" == "verify" ]; then
    TARGET="$1"
    echo "[*] Step 1: Extracting core function (whatis)..."
    whatis "$TARGET" 2>/dev/null || echo "    [!] No short description found."
    
    echo ""
    echo "[*] Step 2: Extracting Command Synopsis (man)..."
    man "$TARGET" 2>/dev/null | col -b | grep -A 7 -i "SYNOPSIS" || echo "    [!] Manual page not found."

elif [ "$ACTION" == "search" ]; then
    KEYWORDS="$*"
    echo "[*] Searching internal manuals for action matching: '$KEYWORDS'..."
    apropos -a $KEYWORDS 2>/dev/null || echo "    [!] No matching system commands found."

else
    echo "[!] Invalid action. Use 'verify' or 'search'."
    exit 1
fi

echo ""
echo "[+] Reconnaissance complete."