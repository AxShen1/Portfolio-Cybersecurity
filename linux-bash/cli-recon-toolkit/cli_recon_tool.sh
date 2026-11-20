#!/usr/bin/env bash
# ==============================================================================
# Script: cli_recon_tool.sh
# Purpose: "Verify before you execute": look up what a Linux command does
#          (whatis, man SYNOPSIS) or find a command by intent (apropos).
# Usage:   ./cli_recon_tool.sh verify <command>
#          ./cli_recon_tool.sh search <keywords...>
# ==============================================================================
set -euo pipefail

usage() {
    cat <<EOF
Usage:
  $0 verify <command>      Show a one-line description and the SYNOPSIS
  $0 search <keywords...>  Find commands whose manual page matches ALL keywords
EOF
    exit 1
}

[ "$#" -ge 2 ] || usage
ACTION="$1"; shift

case "$ACTION" in
    verify)
        TARGET="$1"
        echo "[*] Step 1: Short description (whatis)"
        whatis "$TARGET" 2>/dev/null || echo "    [!] No short description found."
        echo
        echo "[*] Step 2: Synopsis (man)"
        man "$TARGET" 2>/dev/null | col -b | grep -A 7 -i "^SYNOPSIS" \
            || echo "    [!] Manual page not found."
        ;;
    search)
        echo "[*] Searching manual pages for: $*"
        apropos -a "$@" 2>/dev/null || echo "    [!] No matching commands found."
        ;;
    *)
        echo "[!] Unknown action: $ACTION" >&2
        usage
        ;;
esac
