#!/bin/bash

# Generate a simple inventory of installed packages and system info
LOG_DIR="/var/log/sysadmin"
INVENTORY_FILE="$LOG_DIR/system_inventory_$(date +%F).log"
mkdir -p "$LOG_DIR"

{
  echo "===== WEEKLY SYSTEM INVENTORY REPORT: $(date) ====="
  echo -e "\n🔸 Hostname: $(hostname)"
  echo -e "\n🔸 OS Info:"
  uname -a

  echo -e "\n🔸 Disk Info:"
  lsblk

  echo -e "\n🔸 Memory Info:"
  free -h

  echo -e "\n🔸 Installed Packages:"
  if command -v dpkg &>/dev/null; then
    dpkg --get-selections
  elif command -v rpm &>/dev/null; then
    rpm -qa
  fi
  echo "===================================================="
} >> "$INVENTORY_FILE"