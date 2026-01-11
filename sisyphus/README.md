# Proxmox VE Server: `sisyphus`

##  Hardware Specifications

| Component    | Details                          |
|--------------|----------------------------------|
| **CPU**      | AMD Ryzen 7 5700X (8 cores, 16 threads) |
| **RAM**      | 32 GB DDR4 @ 3200 MHz            |
| **Motherboard**  | Gigabyte B550M AORUS Elite             |
| **GPU**       | Nvidia Geforce GTX 610 (Legacy GPU) 
| **GPU**       | Nvidia Geforce RTX 3060 12GB 
| **Storage**  | Western Digital SN770 2TB NVMe (5.5 GB/s)    |
| **TPU**  | google coral tpu    |
| **Power Supply** | Ant Esports RX650M (650W, Semi-Modular)|
| **CPU Cooler**   | Ant Esports C612 Digital Cooler        |
| **Cabinet**         | Ant Esports ICE 112 Mid-Tower          |
| **Video HDD**  | WD Purple surveillance hard drive 6TB  |


---

##  Software Stack

| Component         | Details                                           |
|------------------|---------------------------------------------------|
| **Proxmox VE**    | `9.1.4` (Kernel: `6.17.4-1-pve`)                  |
| **File System**   | ext4 with lvm groups     |
| **Virtualization**| KVM/QEMU for VMs, LXC Containers (planned)       |
| **Container Engine** | Docker (running inside a VM) |
| **Windows VM**    | For direct physical usage via Proxmox passthrough |
| **Hostname** | `sisyphus`                       |
| **outbound connection tunnel** | cloudflare tunnels  |
---

##  Networking

- **VPN** only via [Tailscale](https://tailscale.com) for administration and service access
- No bridged or physical external interface exposed directly
![network](/assets/network/01.png)


---

## Virtual Machines

| VM Name       | Purpose                            | OS          | Notes                            |
|---------------|------------------------------------|-------------|----------------------------------|
| `docker-utility-node`   | runs utility services | Ubuntu server 24.04| runs low resource always on services  |
| `docker-compute-node`   | runs compute services | Ubuntu server 24.04| runs cpu heavy services  |
| `docker-utility-node`   | runs GPU accelereated services | Ubuntu server 24.04| runs gpu accelerated services  |
| `windows-vm`      | personal workstation and gaming | Windows 11  | gpu and usb passthrough   |

---

##  Inspiration 

This setup is part of an ongoing journey in self-hosting, virtual infrastructure design, and automated homelab management — with the goal of mastering production-grade orchestration and DevOps principles on personal hardware.

---

## Screenshots

![0](/assets/proxmox-os/01.png)

## Pictures

![0](/assets/hardware/01.png)
![0](/assets/hardware/02.jpg)
![0](/assets/hardware/03.jpg)
![0](/assets/hardware/04.png)
![0](/assets/hardware/05.mp4)
![0](/assets/hardware/06.jpg)
![0](/assets/hardware/07.png)