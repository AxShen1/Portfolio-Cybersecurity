#!/usr/bin/env bash
# ==============================================================================
# Script: bootstrap.sh
# Purpose: Install basic traffic-analysis tools and compute a simple alert
#          triage baseline (training lab).
# Environment: Debian/Ubuntu (APT). Needs sudo. Use a lab VM or container.
# ==============================================================================
set -euo pipefail

echo "[*] Step 1: Installing traffic analysis tools (tcpdump, nload)..."
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install -y tcpdump nload > /dev/null 2>&1

echo "[+] Installed:"
apt list --installed 2>/dev/null | grep -E "^(tcpdump|nload)/" || true

echo ""
echo "[*] Step 2: Alert triage baseline (example numbers from the lab scenario)..."
TOTAL_ALERTS=32
ACTIONABLE_ALERTS=8
FALSE_POSITIVES=$((TOTAL_ALERTS - ACTIONABLE_ALERTS))
echo "    Total alerts received : $TOTAL_ALERTS"
echo "    Actionable (true pos.): $ACTIONABLE_ALERTS"
echo "    Noise (false pos.)    : $FALSE_POSITIVES"
echo "    False-positive rate   : $((100 * FALSE_POSITIVES / TOTAL_ALERTS))%"

echo ""
echo "[*] Workstation ready for network traffic capture."
