# **Linux Administration & Automation – Step-by-Step Documentation**  

This documentation explains every step of the project, from **Git repository setup**, **Linux server administration**, **networking configuration**, **Bash scripting**, **automation with cron jobs**, **security hardening**, and **backup & recovery**.

---

## **1️⃣ Git Repository Setup**  

We begin by setting up a **Git repository** to organize our project.

### **Step 1: We begin by setting up a **Git repository** to organize our project.

### **Step 2: Create Project Directory Structure**
We create directories for **scripts, configurations, monitoring, and documentation**.

```bash
mkdir -p scripts config monitoring documentation
touch README.md .gitignore
```

### **Step 3: Set Up `.gitignore`**
We ensure Git ignores unnecessary files.

```bash
echo "logs/*" >> .gitignore
echo "*.log" >> .gitignore
echo "backups/*" >> .gitignore
```

### **Step 4: Create a Pre-Commit Hook**
This ensures we don't commit scripts with syntax errors.

```bash
echo -e '#!/bin/bash\nshellcheck scripts/*.sh' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```


## **2️⃣ Linux Server Administration**

We set up **two Linux servers**:  

- **Admin Server** → Used for managing the target server.  
- **Target Server** → The machine we automate and secure.  

### **Step 1: Create a User & Configure SSH**
On both servers, we create a user and set up **key-based authentication**.

```bash
sudo adduser devops
sudo usermod -aG sudo devops
su - devops
mkdir ~/.ssh
chmod 700 ~/.ssh
```

We then copy the public key from the **Admin Server** to the **Target Server**.

```bash
ssh-copy-id devops@target-server-ip
```

### **Step 2: Install Essential Packages**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install ssh nginx git curl htop -y
```

### **Step 3: Configure Services**
We ensure **critical services** (like SSH, web server) are enabled.

```bash
sudo systemctl enable ssh
sudo systemctl enable nginx
sudo systemctl start nginx
```

---

## **3️⃣ Networking Configuration**

We configure **secure networking** between the servers.

### **Step 1: Assign a Static IP**
Edit `/etc/netplan/00-installer-config.yaml`:

```yaml
network:
  ethernets:
    eth0:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
          addresses:
            - 8.8.8.8
            - 8.8.4.4
  version: 2
```

Apply the new configuration:
```bash
sudo netplan apply
```

### **Step 2: Configure a Firewall**
We allow only necessary ports using **UFW**:

```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw enable
```

### **Step 3: Test Private Network**
```bash
ping 192.168.1.101
```

### **Step 4: Set Up DNS Resolution**
We edit `/etc/hosts`:
```bash
192.168.1.101 target-server
192.168.1.102 admin-server
```

---

## **4️⃣ Bash Automation Scripts**

We create **five scripts** for automation.

### **1. System Inventory (`system_inventory.sh`)**
```bash
#!/bin/bash
echo "System Inventory Report"
lscpu | grep "Model name"
free -h
df -h
systemctl list-units --type=service --state=running
```
✅ **Collects CPU, memory, and disk details.**  
✅ **Lists installed services.**  

### **2. User Manager (`user_manager.sh`)**
```bash
#!/bin/bash
case "$1" in
  add) sudo adduser "$2" ;;
  remove) sudo deluser "$2" ;;
  *) echo "Usage: $0 {add|remove} username" ;;
esac
```
✅ **Adds & removes users.**  
✅ **Manages SSH keys & groups.**  

### **3. System Hardening (`system_hardening.sh`)**
```bash
#!/bin/bash
echo "Disabling Root Login..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```
✅ **Disables root login.**  
✅ **Updates system packages.**  

### **4. Network Monitor (`network_monitor.sh`)**
```bash
#!/bin/bash
echo "Active Network Connections:"
netstat -tulnp
```
✅ **Tracks network connections.**  
✅ **Logs unusual activity.**  

### **5. Backup Manager (`backup_manager.sh`)**
```bash
#!/bin/bash
tar -czf /backups/backup_$(date +%F).tar.gz /etc
find /backups -mtime +7 -delete
```
✅ **Creates daily backups.**  
✅ **Deletes old backups.**  

---

## **5️⃣ Cron Jobs & Logging**

We automate system tasks using **cron jobs**.

### **Step 1: Configure Cron Jobs**
```bash
crontab -e
```
Add the following:
```bash
@weekly /home/adminuser/scripts/system_inventory.sh
@hourly /home/adminuser/scripts/network_monitor.sh
@daily /home/adminuser/scripts/backup_manager.sh
```