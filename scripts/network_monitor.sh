#!/bin/bash

# Network Monitoring Script

LOG_FILE="/var/log/network_monitor.log"

echo "Network Monitoring - $(date)" >> $LOG_FILE
echo "---------------------------------" >> $LOG_FILE

# Active network connections
echo "Active Connections:" >> $LOG_FILE
netstat -tulnp | grep LISTEN >> $LOG_FILE

# Bandwidth usage
echo -e "\nBandwidth Usage:" >> $LOG_FILE
if command -v iftop &> /dev/null; then
    sudo iftop -t -s 10 >> $LOG_FILE
else
    echo "Install 'iftop' to monitor bandwidth usage." >> $LOG_FILE
fi

echo "Network Monitoring Completed!" >> $LOG_FILE