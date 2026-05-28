# Self-Hosted Documentation

This repository documents my self-hosted homelab: server notes, Docker Compose stacks, helper scripts, and troubleshooting references.

## Overview

The setup is centered around a Proxmox host named `sisyphus`, with Docker workloads split across utility, compute, and GPU-accelerated nodes.

| Node | GPU | CPU | RAM | Storage | Role |
| --- | --- | --- | --- | --- | --- |
| `sisyphus` | NVIDIA GeForce RTX 3060 | AMD Ryzen 7 5700X | 32 GB DDR4 | 2 TB NVMe, 6 TB HDD | Main compute and storage host |

## Stack

- **Virtualization:** Proxmox VE
- **Container runtime:** Docker inside Ubuntu Server VMs
- **Networking:** Tailscale, Cloudflare Tunnel, nginx reverse proxy
- **Storage:** ext4/LVM with dedicated Docker data paths
- **Backups:** BorgBackup and service-level data exports

## Layout

```text
sisyphus/
  docker-accel-node/      GPU-heavy Docker services
  docker-compute-node/    CPU-heavy Docker services
  docker-utility-node/    Lightweight always-on services
  nginx-edge-node/        Cloudflare Tunnel and nginx edge proxy notes
  scripts/                Helper scripts for Docker and storage tasks
  trash/                  Archived or retired services
```

## License

This documentation is released under the [MIT License](LICENSE).
