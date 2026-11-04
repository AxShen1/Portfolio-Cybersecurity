#!/bin/bash
# ==============================================================================
# Script: bootstrap.sh
# Purpose: Provisioning minimal SOC analysis environment & calculating triage baseline
# Environment: Debian/Ubuntu (APT)
# ==============================================================================

set -e

echo "[*] Step 1: Updating packages and provisioning traffic analysis tools..."
sudo apt update -y > /dev/null 2>&1
sudo apt install -y tcpdump nload > /dev/null 2>&1

echo "[+] Tools provisioned successfully:"
apt list --installed 2>/dev/null | grep -E "tcpdump|nload"

echo ""
echo "[*] Step 2: Calculating SOC Alert Baseline (False Positive Triage)..."
TOTAL_ALERTS=32
ACTIONABLE_ALERTS=8

# Obliczenie False Positives w Bashu (odpowiednik ćwiczenia z laba)
FALSE_POSITIVES=$(expr $TOTAL_ALERTS - $ACTIONABLE_ALERTS)
echo "    Total Alerts Received : $TOTAL_ALERTS"
echo "    True Positives (Action): $ACTIONABLE_ALERTS"
echo "    False Positives (Noise): $FALSE_POSITIVES"

echo ""
echo "[*] Workstation ready for network traffic capture."