#!/usr/bin/env bash
# ==============================================================================
# crypto_toolkit.sh - Caesar cipher breaker + AES-256-CBC encrypt/decrypt wrapper
# Context : Security analyst lab - recovering "ransomware-encrypted" files
# Requires: bash, tr, openssl
# ==============================================================================
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  $0 caesar <shift> [file]              Decrypt a Caesar cipher (text shifted LEFT by <shift>)
  $0 bruteforce [file]                  Try all 25 shifts, print each candidate
  $0 decrypt <in> <out> [password]      AES-256-CBC (PBKDF2, base64) decrypt
  $0 encrypt <in> <out> [password]      AES-256-CBC (PBKDF2, base64) encrypt
  $0 selftest                           Round-trip test of all functions

If [password] is omitted you are prompted (safer: a password passed as an
argument is visible to other users in 'ps' and stays in shell history).

Lab example:
  $0 caesar 3 .leftShift3
  $0 decrypt Q1.encrypted Q1.recovered ettubrute
USAGE
  exit 1
}

caesar_decrypt() {  # $1 = left shift, stdin -> stdout
  local n=$(( $1 % 26 ))
  local lo=abcdefghijklmnopqrstuvwxyz up=ABCDEFGHIJKLMNOPQRSTUVWXYZ
  tr "${lo:n}${lo:0:n}${up:n}${up:0:n}" "${lo}${up}"
}

read_pass() {  # $1 = optional password argument
  if [[ -n "${1:-}" ]]; then printf '%s' "$1"
  else read -rsp "Password: " p; echo >&2; printf '%s' "$p"; fi
}

cmd=${1:-}; [[ -z "$cmd" ]] && usage
shift

case "$cmd" in
  caesar)
    [[ $# -ge 1 ]] || usage
    shift_n=$1; src=${2:-/dev/stdin}
    caesar_decrypt "$shift_n" < "$src" ;;
  bruteforce)
    src=${1:-/dev/stdin}; data=$(cat "$src")
    for n in $(seq 1 25); do printf '[shift %2d] ' "$n"; caesar_decrypt "$n" <<< "$data" | head -n1; done ;;
  decrypt|encrypt)
    [[ $# -ge 2 ]] || usage
    in=$1; out=$2
    [[ -f "$in" ]] || { echo "[-] Input file not found: $in" >&2; exit 2; }
    export CT_PASS; CT_PASS=$(read_pass "${3:-}")
    flag=-d; [[ "$cmd" == encrypt ]] && flag=-e
    if openssl aes-256-cbc -pbkdf2 -a $flag -in "$in" -out "$out" -pass env:CT_PASS; then
      echo "[+] ${cmd^}ion OK -> $out"
    else
      echo "[-] ${cmd^}ion failed (wrong password or corrupted file?)" >&2; exit 3
    fi ;;
  selftest)
    t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
    echo "Hello Analyst" > "$t/plain"
    echo "Khoor Dqdobvw" | caesar_decrypt 3 | grep -qx "Hello Analyst" && echo "[+] Caesar OK"
    "$0" encrypt "$t/plain" "$t/enc" pw >/dev/null && "$0" decrypt "$t/enc" "$t/dec" pw >/dev/null
    cmp -s "$t/plain" "$t/dec" && echo "[+] AES round-trip OK" ;;
  *) usage ;;
esac
