#!/bin/bash

# Define backup source and destination
SOURCE_DIR="/etc"
BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +%F)
BACKUP_FILE="$BACKUP_DIR/etc-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# Keep only last 7 backups
find "$BACKUP_DIR" -name "etc-backup-*.tar.gz" -mtime +7 -exec rm {} \;

# Log result
echo "[$(date)] Backup created at $BACKUP_FILE" >> /var/log/sysadmin/daily_backup.log