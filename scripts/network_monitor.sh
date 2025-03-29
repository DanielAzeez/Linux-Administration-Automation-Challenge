#!/bin/bash

# Backup Manager Script

BACKUP_DIR="/backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup_manager.log"

mkdir -p $BACKUP_DIR

# Perform backup
echo "Starting backup at $TIMESTAMP..." >> $LOG_FILE
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" /etc /home

# Keep only last 5 backups
echo "Rotating backups..." >> $LOG_FILE
ls -1t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs rm -f

echo "Backup completed at $(date)" >> $LOG_FILE