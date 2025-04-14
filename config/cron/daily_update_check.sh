#!/bin/bash

# Location to store the log
LOG_DIR="/var/log/sysadmin"
LOG_FILE="$LOG_DIR/daily_update_check.log"
mkdir -p "$LOG_DIR"

{
  echo "========== SYSTEM UPDATE CHECK: $(date) =========="
  if command -v apt &>/dev/null; then
    apt update -qq
    apt list --upgradable 2>/dev/null | grep -v "Listing..."
  elif command -v yum &>/dev/null; then
    yum check-update
  else
    echo "⚠️ Unsupported package manager."
  fi
  echo "==================================================="
} >> "$LOG_FILE" 2>&1