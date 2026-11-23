#!/usr/bin/env bash
# vm_health_check.sh - READ-ONLY report for a Kali/Debian VM. Changes nothing.
# Checks: default accounts, listening ports, pending updates, network speed.
# Usage: ./vm_health_check.sh
set -u

hr() { printf '\n== %s ==\n' "$1"; }

hr "Accounts that look like defaults"
if id kali >/dev/null 2>&1; then
    echo "[!] account 'kali' exists (default name of the pre-built image). If it is still"
    echo "    in use, confirm its password is NOT the published default; consider renaming."
else
    echo "[+] no account named 'kali'."
fi
echo "Interactive users (UID >= 1000):"
awk -F: '$3>=1000 && $7!~/nologin|false/ {print "  " $1}' /etc/passwd

hr "Listening network services"
if command -v ss >/dev/null; then ss -tulpn 2>/dev/null | head -n 20; else echo "ss not available"; fi

hr "Pending updates (apt, no changes made)"
if command -v apt-get >/dev/null; then
    apt-get -s upgrade 2>/dev/null | grep -c '^Inst ' | sed 's/^/Upgradable packages: /'
else
    echo "apt not available"
fi

hr "Network: routes and DNS servers"
ip route 2>/dev/null | head -n 5
grep -E '^nameserver' /etc/resolv.conf 2>/dev/null

hr "Network: timings (seconds)"
t() { local s=$EPOCHREALTIME rc=0; "$@" >/dev/null 2>&1 || rc=$?; awk -v a="$s" -v b="$EPOCHREALTIME" -v l="$LABEL" -v r="$rc" 'BEGIN{printf "%s (rc=%s): %.2f\n", l, r, b-a}'; }
if command -v getent >/dev/null; then LABEL="DNS lookup of debian.org"; t getent hosts debian.org; fi
if command -v curl >/dev/null; then
    LABEL="IPv4 HTTPS HEAD"; t curl -4 -sS -m 15 -I https://debian.org
    LABEL="IPv6 HTTPS HEAD"; t curl -6 -sS -m 15 -I https://debian.org
fi
echo
echo "Reading the numbers: slow DNS -> resolver problem; IPv6 failing/slow while IPv4 is fast -> IPv6 path issue."
