#!/bin/bash

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



