# ⚙️ Bash Automation Scripts

This document provides a detailed explanation of the bash automation scripts designed to support Linux server administration and security in this project. These scripts handle routine tasks such as auditing, user management, system hardening, monitoring, and backups.

---

## 📁 List of Scripts

1. [`system_inventory`](#1-system_inventory)
2. [`user_manager`](#2-user_manager)
3. [`system_hardening`](#3-system_hardening)
4. [`network_monitor`](#4-network_monitor)
5. [`backup_manager`](#5-backup_manager)

# ⚙️ Bash Automation Scripts
---

## 🖥️ 1. `system_inventory`
```#!/bin/bash
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
```

This script generates a complete inventory report of the system’s key components and resources. It collects vital system data and prints them in a human-readable format. It includes:

- **CPU Info**: Extracts model name and CPU frequency using `lscpu`.
- **Memory Info**: Displays memory usage statistics using `free -h`, showing available, used, and total memory in human-readable format.
- **Disk Info**: Uses `df -h` to report disk space usage across all mounted filesystems.
- **Installed Packages**: Counts how many software packages are installed using `dpkg --get-selections`.
- **Running Services**: Lists currently active system services using `systemctl` to give insight into what's running.

Ideal for generating weekly system status reports or before-and-after snapshots for configuration changes.

---

## 👤 2. `user_manager`

This is a versatile user management script that accepts three commands (`create`, `delete`, and `add-key`) with parameters to manage users efficiently.

- **`create`**: Adds a new user with a home directory and assigns `/bin/bash` as the default shell.
- **`delete`**: Deletes a user and their home directory.
- **`add-key`**: Sets up SSH key-based authentication for a user by:
  - Creating the `.ssh` directory
  - Writing the given public key to `authorized_keys`
  - Applying proper file and directory permissions
  - Ensuring ownership is set correctly
    
```#!/bin/bash

# User Manager Script

ACTION=$1
USERNAME=$2
SSH_KEY=$3

case $ACTION in
  create)
    sudo useradd -m -s /bin/bash "$USERNAME"
    echo "User $USERNAME created."
    ;;
  delete)
    sudo userdel -r "$USERNAME"
    echo "User $USERNAME deleted."
    ;;
  add-key)
    mkdir -p /home/$USERNAME/.ssh
    echo "$SSH_KEY" > /home/$USERNAME/.ssh/authorized_keys
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
    chown -R "$USERNAME":"$USERNAME" /home/$USERNAME/.ssh
    echo "SSH key added for $USERNAME."
    ;;
  *)
    echo "Usage: $0 {create|delete|add-key} username [ssh_key]"
    exit 1
    ;;
esac
```

This script makes managing user access—especially for remote SSH logins—easy and secure.

---

## 🔐 3. `system_hardening`

This script implements basic security best practices to reduce the system’s attack surface and enforce stronger default protections.

- **Disables Root SSH Login**: Modifies the SSH configuration to prevent remote login as root, mitigating brute-force and privilege abuse risks.
- **Disables Unnecessary Services**: Shuts down and disables services like `cups` and `avahi-daemon` which are often unused and can introduce vulnerabilities.
- **Performs System Updates**: Ensures all installed packages are up-to-date with `apt update` and `apt upgrade -y`.
- **Configures Firewall**: Enables UFW (Uncomplicated Firewall), allowing only SSH traffic and denying all others by default.

```#!/bin/bash

# System Hardening Script

echo "Starting system hardening..."

# Disable root SSH login
echo "Disabling root SSH login..."
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Disable unused services
echo "Disabling unnecessary services..."
sudo systemctl disable cups
sudo systemctl disable avahi-daemon

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# Configure basic firewall
echo "Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw enable

echo "System hardening complete!"
```

This script is essential for initial server setup and periodic hardening cycles.

---

## 🌐 4. `network_monitor`

This script provides insight into the network state of the server and optionally measures bandwidth.

- **Logs Current Network State**:
  - Lists all listening ports and associated services using `netstat -tulnp | grep LISTEN`.
- **Bandwidth Monitoring**:
  - Checks if the `iftop` utility is installed.
  - If present, runs `iftop` in text mode for 10 seconds to log bandwidth usage.
  - If not installed, provides a helpful message prompting the user to install it.

```#!/bin/bash

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
```

Great for hourly or daily network audits and detecting abnormal network activity.

---

## 💾 5. `backup_manager`

This script automates backups of important system directories and implements a basic backup rotation policy.

- **Backup Execution**:
  - Archives and compresses `/etc` and `/home` directories using `tar`.
  - Names the backup files with a timestamp for traceability.
- **Backup Rotation**:
  - Keeps only the **five most recent** backups.
  - Older backups are deleted automatically using `ls`, `tail`, and `xargs rm`.

```#!/bin/bash

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
```

It’s a reliable way to preserve configuration files and user data with minimal intervention.
