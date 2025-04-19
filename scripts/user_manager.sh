#!/bin/bash

# User Manager Script with Safe Operations

# Usage:
# ./user_manager.sh {create|delete|add-key} username [ssh_key]

ACTION=$1
USERNAME=$2
SSH_KEY=$3
LOG_FILE="/var/log/user_manager.log"

# --- Helpers ---
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

user_exists() {
  id "$1" &>/dev/null
}

# --- Pre-flight checks ---
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if [[ -z "$ACTION" || -z "$USERNAME" ]]; then
  echo "Usage: $0 {create|delete|add-key} username [ssh_key]"
  exit 1
fi

USER_HOME=$(eval echo "~$USERNAME")

# --- Actions ---
case $ACTION in
  create)
    if user_exists "$USERNAME"; then
      log "User $USERNAME already exists."
      exit 1
    fi
    useradd -m -s /bin/bash "$USERNAME"
    log "User $USERNAME created."
    ;;

  delete)
    if ! user_exists "$USERNAME"; then
      log "User $USERNAME does not exist."
      exit 1
    fi
    userdel -r "$USERNAME"
    log "User $USERNAME deleted."
    ;;

  add-key)
    if ! user_exists "$USERNAME"; then
      log "User $USERNAME does not exist."
      exit 1
    fi
    if [[ -z "$SSH_KEY" ]]; then
      echo "Error: SSH key is required for add-key action."
      exit 1
    fi
    mkdir -p "$USER_HOME/.ssh"
    touch "$USER_HOME/.ssh/authorized_keys"
    grep -qxF "$SSH_KEY" "$USER_HOME/.ssh/authorized_keys" || echo "$SSH_KEY" >> "$USER_HOME/.ssh/authorized_keys"
    chmod 700 "$USER_HOME/.ssh"
    chmod 600 "$USER_HOME/.ssh/authorized_keys"
    chown -R "$USERNAME":"$USERNAME" "$USER_HOME/.ssh"
    log "SSH key added for $USERNAME."
    ;;

  *)
    echo "Usage: $0 {create|delete|add-key} username [ssh_key]"
    exit 1
    ;;
esac
