#!/usr/bin/env bash
# ==============================================================================
# fim_comparator.sh - File integrity check & hash comparator
# Compares two files by cryptographic hash and, if they differ, shows WHERE
# (cmp + hex view), because files that look identical on screen can still differ
# in invisible bytes (trailing newline, spaces, look-alike characters).
#
# Usage:   ./fim_comparator.sh [-a sha256|sha1|sha512|md5] <file1> <file2>
# Exit:    0 = identical, 1 = different, 2 = usage/file error
# Requires: bash, coreutils (sha256sum, od, stat), diffutils (cmp, diff)
# ==============================================================================
set -uo pipefail

algo=sha256
if [[ "${1:-}" == "-a" ]]; then algo=${2:-}; shift 2 || true; fi
case "$algo" in sha256|sha1|sha512|md5) ;; *) echo "Unsupported algorithm: $algo" >&2; exit 2 ;; esac
[[ $# -eq 2 ]] || { sed -n '8,10p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

f1=$1; f2=$2
for f in "$f1" "$f2"; do [[ -r "$f" ]] || { echo "[-] Cannot read file: $f" >&2; exit 2; }; done

sum() { "${algo}sum" "$1" | awk '{print $1}'; }
h1=$(sum "$f1"); h2=$(sum "$f2")

echo "=== File integrity check (${algo^^}) ==="
printf '%-10s %s\n  size: %s bytes\n  hash: %s\n' "File 1:" "$f1" "$(stat -c %s "$f1")" "$h1"
printf '%-10s %s\n  size: %s bytes\n  hash: %s\n' "File 2:" "$f2" "$(stat -c %s "$f2")" "$h2"
echo

if [[ "$h1" == "$h2" ]]; then
  echo "[+] MATCH: files are identical."
  exit 0
fi

echo "[-] MISMATCH: files are different."
echo
echo "--- First difference (cmp) ---"
cmp "$f1" "$f2"
echo
echo "--- Differing bytes (offset, octal values; first 10) ---"
cmp -l "$f1" "$f2" 2>&1 | head -n 10
echo
echo "--- Hex diff (first differing lines) ---"
diff <(od -v -A d -t x1z "$f1") <(od -v -A d -t x1z "$f2") | head -n 12
exit 1
