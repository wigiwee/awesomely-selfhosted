# 🖥️ Proxmox Server Hardware – `sisyphus`

This is my self-built **Proxmox Virtual Environment** server, designed specifically for virtualization, containerization, and homelabbing workflows.

---

## ⚙️ Core Hardware Specifications

| Component        | Details                                |
|------------------|----------------------------------------|
| **CPU**          | AMD Ryzen 7 5700X (8 cores, 16 threads)|
| **GPU**          | NVIDIA GT 610 (Legacy GPU)             |
| **Motherboard**  | Gigabyte B550M AORUS Elite             |
| **RAM**          | 32 GB Patriot DDR4 @ 3200 MHz          |
| **Storage**      | 512 GB Micron NVMe SSD                 |
| **Power Supply** | Ant Esports RX650M (650W, Semi-Modular)|
| **CPU Cooler**   | Ant Esports C612 Digital Cooler        |
| **Case**         | Ant Esports ICE 112 Mid-Tower          |

---

## 🧪 Use Case

This system runs **Proxmox VE** as its main operating system and is used for:

- 💻 Hosting virtual machines & LXC containers  
- 🐳 Running Docker workloads in VMs  
- 🔁 Experimenting with automation via Ansible (future)  
- 🌐 Tinkering with VPNs (Tailscale), dev stacks, and homelab tools

---

## 🛠️ Build Philosophy

> _Built from scratch to be quiet, efficient, and reliable._

- Minimal GPU included for basic output — no heavy graphical workloads
- RAM and NVMe optimized for fast I/O and multitasking in VMs
- PSU and airflow designed for 24/7 uptime

---



## 🧠 Notes

- No rainbow vomit — just clean and functional
- GPU might be upgraded for passthrough testing in future
- Additional storage planned if VM load increases

---

> 🚀 *Simple. Stable. Homelab-ready.*
