#!/bin/bash

# System Inventory Script

echo "System Inventory Report - $(date)"
echo "---------------------------------"

# CPU Info
echo "CPU Information:"
lscpu | grep "Model name\|CPU MHz"

# Memory Info
echo -e "\nMemory Information:"
free -h

# Disk Info
echo -e "\nDisk Usage:"
df -h

# Installed Packages
echo -e "\nInstalled Packages:"
dpkg --get-selections | wc -l

# Running Services
echo -e "\nRunning Services:"
systemctl list-units --type=service --state=running | grep ".service"

echo -e "\nInventory Report Completed!"