#!/usr/bin/env bash
# verify_download.sh - compare a file's SHA-256 with the hash published by the vendor.
# Usage: ./verify_download.sh <file> <expected_sha256>
# Exit:  0 match, 1 mismatch, 2 usage/error
set -euo pipefail

[ "$#" -eq 2 ] || { echo "Usage: $0 <file> <expected_sha256>" >&2; exit 2; }
FILE="$1"
EXPECTED="$(printf '%s' "$2" | tr 'A-F' 'a-f' | tr -d '[:space:]')"

[ -f "$FILE" ] || { echo "[!] File not found: $FILE" >&2; exit 2; }
[[ "$EXPECTED" =~ ^[0-9a-f]{64}$ ]] || { echo "[!] Expected hash must be 64 hex characters." >&2; exit 2; }

ACTUAL="$(sha256sum "$FILE" | awk '{print $1}')"
echo "Expected: $EXPECTED"
echo "Actual:   $ACTUAL"
if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "[+] MATCH: file integrity verified."
else
    echo "[-] MISMATCH: do not use this file. Re-download from the official site." >&2
    exit 1
fi
