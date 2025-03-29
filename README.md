# Linux-Administration-Automation-Challenge


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
cd linux-admin-automation
```
### 2. Setup Key-Based SSH Authentication
```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id user@target-server-ip
```
### 3. Configure Firewall
```bash
sudo ufw allow ssh
sudo ufw enable
```
### 4. Run Scripts
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

---

## Networking Configuration
### 1. Static IP Address Setup
```bash
sudo nano /etc/network/interfaces
```
Example configuration:
```
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
```

### 2. Firewall Rules
```bash
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 80/tcp  # HTTP
sudo ufw allow 443/tcp # HTTPS
sudo ufw enable
```

---

## Scheduled Tasks (Cron Jobs)
### Setup Scheduled Jobs:
```bash
crontab -e
```
Example cron jobs:
```
0 0 * * 7 /path/to/system_inventory.sh  # Weekly inventory
0 * * * * /path/to/network_monitor.sh   # Hourly network monitoring
0 2 * * * /path/to/backup_manager.sh    # Daily backups at 2 AM
```

---

## Troubleshooting
### 1. Permission Denied on Scripts
```bash
chmod +x scripts/*.sh
```
### 2. SSH Key Authentication Fails
Ensure the `~/.ssh/authorized_keys` file exists and has the correct permissions:
```bash
chmod 600 ~/.ssh/authorized_keys
```
### 3. Firewall Blocks SSH
```bash
sudo ufw allow ssh
```

---

## Contributing
1. Fork the repository.
2. Create a feature branch.
3. Commit changes with meaningful messages.
4. Open a pull request.

---
