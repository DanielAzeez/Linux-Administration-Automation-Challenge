### Networking Configuration Documentation

This section covers the networking setup between the admin and target Linux virtual machines. The goal is secure, static, and restricted communication.

---

## 🧭 Network Topology

![Image](https://github.com/user-attachments/assets/dca57d00-a3ea-43e7-ab4f-8424c8fd5b2b)

### 🗺️ IP Addressing

| Device       | IP Address      | Hostname     |
|--------------|------------------|--------------|
| Admin Server | `192.168.1.102`  | `admin-vm`   |
| Target Server| `192.168.1.101`  | `target-vm`  |

```
[ Admin VM (192.168.1.102) ] <---> [ Target VM (192.168.1.101) ]
            ↕                                  ↕
     SSH key-based auth              UFW firewall restrictions
```

---

## 📌 Static IP Configuration

Edit `/etc/netplan/01-netcfg.yaml` on both machines:

```yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 192.168.1.102/24  # On admin-vm (use .101 on target-vm)
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

Apply settings:

```bash
sudo netplan apply
```

---

## 🔐 SSH Key Authentication

- Admin VM can securely SSH into Target VM using the SSH key configured in Part 2.

---

## 🔥 Firewall Configuration using UFW

### Enable and configure UFW:

```bash
sudo ufw allow OpenSSH
sudo ufw allow from 192.168.1.102 to any port 22 proto tcp
sudo ufw enable
```

### Verify rules:

```bash
sudo ufw status verbose
```

---

## 🌉 Private Networking

- Both VMs are connected on the 192.168.1.0/24 subnet.
- They can ping each other directly:

```bash
ping 192.168.1.101  # From admin-vm
```

---

## 🌐 DNS Resolution via /etc/hosts

Update the `/etc/hosts` file:

### On `admin-vm`:

```bash
echo "192.168.1.101 target-vm" | sudo tee -a /etc/hosts
```

### On `target-vm`:

```bash
echo "192.168.1.102 admin-vm" | sudo tee -a /etc/hosts
```

Test it:

```bash
ping target-vm
```
---

### 🔐 Firewall Rules

| Rule                                           | Description                                 |
|------------------------------------------------|---------------------------------------------|
| `ufw allow OpenSSH`                            | Allow SSH access                            |
| `ufw allow from 192.168.1.102 to any port 22`  | Only admin-vm can SSH into target-vm        |

---

### 🚪 Service Ports in Use

| Service     | Port |
|-------------|------|
| SSH         | 22   |
| UFW         | N/A  |

---

Networking between both VMs is secured, statically addressed, and restricted using a firewall.
