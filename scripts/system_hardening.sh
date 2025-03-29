#!/bin/bash

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



