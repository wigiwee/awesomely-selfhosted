# 🧰 Proxmox VE Server: `sisyphus`

Welcome to the documentation for my self-hosted **Proxmox Virtual Environment** setup, codenamed **`sisyphus`** — a powerful, Tailscale-secured virtual infrastructure built for experimentation, homelab use, and hands-on automation.

---

## 🖥️ Hardware Specifications

| Component    | Details                          |
|--------------|----------------------------------|
| **CPU**      | AMD Ryzen 7 5700X (8 cores, 16 threads) |
| **RAM**      | 32 GB DDR4 @ 3200 MHz            |
| **GPU**       | Nvidia Geforce 610 
| **Storage**  | 512 GB Micron NVMe (3.5 GB/s)    |
| **Hostname** | `sisyphus`                       |

---

## ⚙️ Software Stack

| Component         | Details                                           |
|------------------|---------------------------------------------------|
| **Proxmox VE**    | `8.4.1` (Kernel: `6.8.12-9-pve`)                  |
| **File System**   | (TBD – default or custom FS not yet defined)     |
| **Virtualization**| KVM/QEMU for VMs, LXC Containers (planned)       |
| **Container Engine** | Docker (running inside a VM via community script) |
| **Windows VM**    | For direct physical usage via Proxmox passthrough |

---

## 🔐 Security & Remote Access

- **2FA** enabled on the Proxmox web interface
- **SSH** access: enabled ( key based only )
- **VPN**: Connected via **Tailscale**, allowing secure, peer-to-peer access
  - Access is **restricted to specific, approved devices only**

---

## 🌐 Networking

- **VPN** only via [Tailscale](https://tailscale.com) for administration and service access
- No bridged or physical external interface exposed directly


---

## 📦 Virtual Machines

| VM Name       | Purpose                            | OS          | Notes                            |
|---------------|------------------------------------|-------------|----------------------------------|
| `docker-vm`   | Self-hosting stack (Docker Engine) | Debian| Created using community script of docker   |
| `win-vm`      | Personal workstation                | Windows     | GPU and USB passthrough   |

---

## 🚧 Work in Progress

### 🔧 Planned Features

- 🔄 **Automated provisioning** via **Ansible** playbooks
- 📦 **Custom ISOs/Templates** with cloud-init and pre-installed agents
- 🧠 Monitoring with **Netdata** or **Prometheus + Grafana**
- 🧯 Backup strategy using **Proxmox Backup Server** or NFS target
- 📈 Resource logging, auto-scaling VM tests, and HA experiments

---

## 📝 Notes

- Currently no snapshot or backup schedule is implemented. Data on VMs and containers is volatile — this will be addressed in upcoming phases.
- Docker is running inside a VM rather than directly on LXC containers for flexibility and isolation.
- System is actively evolving; the README will be updated with each infrastructure change.

---

## 📌 Tags

`#Proxmox` `#Homelab` `#Tailscale` `#Ansible` `#Docker` `#SelfHosted`

---

## 🧠 Inspiration 

This setup is part of an ongoing journey in self-hosting, virtual infrastructure design, and automated homelab management — with the goal of mastering production-grade orchestration and DevOps principles on personal hardware.

---

## Pictures
![0](/assets/proxmox-os/01.png)