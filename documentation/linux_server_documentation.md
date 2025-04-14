### Linux Server Administration Documentation

This section outlines the setup of my two Linux virtual machines — one Admin Server and one Target Server — to demonstrate core aspects of Linux system administration.

---

## 🖥️ Virtual Machines Overview

| Server Type   | Hostname     | IP Address      |
|---------------|--------------|-----------------|
| Admin Server  | `admin-vm`   | `192.168.1.102` |
| Target Server | `target-vm`  | `192.168.1.101` |

---

## 👤 User Management

### Create a user and assign appropriate permissions

```bash
sudo adduser devops
sudo usermod -aG sudo devops
```

---

## 🔐 SSH Configuration with Key-Based Authentication

1. **Generate SSH keys on Admin VM:**

```bash
ssh-keygen -t rsa -b 4096 -C "devops@admin-vm"
```

2. **Copy public key to Target VM:**

```bash
ssh-copy-id devops@192.168.1.101
```

3. **Verify SSH access:**

```bash
ssh devops@192.168.1.101
```

---

## 📦 Package Management

Install required packages:

```bash
sudo apt update && sudo apt install -y vim curl htop net-tools unzip ufw nginx
```

---

## 🔧 Service Management

1. **Enable and start SSH:**

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

2. **Check SSH status:**

```bash
sudo systemctl status ssh
```

---

## 💾 File System Management

1. **Partition and format disk (e.g., `/dev/sdb`):**

```bash
sudo fdisk /dev/sdb          # Create /dev/sdb1
sudo mkfs.ext4 /dev/sdb1
```

2. **Mount and persist storage:**

```bash
sudo mkdir /mnt/storage
sudo mount /dev/sdb1 /mnt/storage
echo '/dev/sdb1 /mnt/storage ext4 defaults 0 2' | sudo tee -a /etc/fstab
```

---

## 📈 Process Management

- View processes:

```bash
top
# or
htop
```

- Kill a process:

```bash
kill -9 <PID>
```

---

My servers were configured using these steps. `admin-vm` manages `target-vm` via secure key-based SSH.
