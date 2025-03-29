# Linux Administration & Automation Challenge

## Overview
This project is designed to demonstrate Linux system administration, automation using Bash scripts, networking configuration, and system monitoring. It includes automation tools for managing a Linux server environment, tracking changes with Git, and monitoring system performance.

---

## Repository Structure
```
├── scripts/             # Automation scripts
│   ├── system_inventory.sh  # Collects system info
│   ├── user_manager.sh      # Manages users and SSH keys
│   ├── system_hardening.sh  # Implements security measures
│   ├── network_monitor.sh   # Monitors network activity
│   ├── backup_manager.sh    # Handles backups
│
├── config/              # Configuration files
├── monitoring/          # Monitoring scripts and logs
├── documentation/       # Project documentation
│   ├── NETWORK_DOC.md       # Network topology and security
│   ├── USAGE_GUIDE.md       # Guide on using the scripts
│
├── .gitignore           # Ignored files for Git
├── README.md            # This documentation file
```

---

## Prerequisites
Ensure you have the following tools installed:
- Linux-based operating system
- Git
- Bash shell
- `ufw` or `iptables` for firewall configuration
- `cron` for scheduled jobs

---

## Getting Started
### 1. Clone the Repository
```bash
git clone https://github.com/DanielAzeez/Linux-Administration-Automation-Challenge.git
cd Linux-Administration-Automation-Challenge
```
### 2. Run Scripts
#### a. System Inventory Script
```bash
./scripts/system_inventory.sh
```
#### b. User Management Script
```bash
./scripts/user_manager.sh
```
#### c. System Hardening Script
```bash
./scripts/system_hardening.sh
```
#### d. Network Monitoring Script
```bash
./scripts/network_monitor.sh
```
#### e. Backup Management Script
```bash
./scripts/backup_manager.sh
```

---

## Script Details
### 1. `system_inventory.sh`
- Collects hardware information (CPU, memory, disk usage)
- Lists installed packages
- Identifies running services

### 2. `user_manager.sh`
- Creates, modifies, and removes users
- Configures SSH key authentication
- Implements password policies

### 3. `system_hardening.sh`
- Secures SSH configuration
- Disables unnecessary services
- Updates all system packages

### 4. `network_monitor.sh`
- Monitors active network connections
- Logs unusual network activity
- Reports bandwidth usage

### 5. `backup_manager.sh`
- Creates timestamped backups
- Implements rotation policy
- Verifies backup integrity

