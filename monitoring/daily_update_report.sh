#!/bin/bash

# Define output log
REPORT_DIR="/var/log/sysadmin"
REPORT="$REPORT_DIR/daily_audit_report_$(date +%F).log"
mkdir -p "$REPORT_DIR"
touch "$REPORT"

# Redirect all stdout and stderr to the report
exec >> "$REPORT" 2>&1

echo "================= DAILY SYSTEM AUDIT REPORT ================="
echo "DATE: $(date)"
echo "HOSTNAME: $(hostname)"
echo "============================================================"

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 SYSTEM UPTIME:"
uptime

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 DISK USAGE:"
df -h --total

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 MEMORY USAGE:"
free -h

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 CPU USAGE (Top 5 Processes):"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 FAILED LOGIN ATTEMPTS (last 24 hrs):"
lastb -F | awk -v d="$(date --date='yesterday' '+%Y-%m-%d')" '$0 ~ d'

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 PENDING PACKAGE UPDATES:"
if command -v apt >/dev/null; then
  apt update -qq
  apt list --upgradable 2>/dev/null | grep -v "Listing..."
elif command -v yum >/dev/null; then
  yum check-update
fi

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 SECURITY LOG ANALYSIS (auth.log / secure):"
SECURITY_LOG="/var/log/auth.log"
[ ! -f "$SECURITY_LOG" ] && SECURITY_LOG="/var/log/secure"
grep -Ei "failed|invalid|error|unauthorized|refused" "$SECURITY_LOG" | tail -n 20

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 BASIC SECURITY AUDIT:"
echo "[✓] Checking world-writable files:"
find / -xdev -type f -perm -0002 -exec ls -l {} \; 2>/dev/null | head -n 10

echo -e "\n[✓] Checking users with UID 0 (should only be root):"
awk -F: '$3 == 0 { print $1 }' /etc/passwd

echo -e "\n[✓] Checking open ports:"
ss -tuln | grep LISTEN

echo -e "\n[✓] Checking for SUID/SGID files:"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null | head -n 10

# ─────────────────────────────────────────────────────────────
echo -e "\n🔸 END OF REPORT"
echo "============================================================"