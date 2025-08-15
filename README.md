# Self-Hosted Documentation

This repository contains detailed documentation of my self-hosting setup, including installation steps, configurations, and troubleshooting notes for various services.

## About
This documentation serves as a central knowledge base for managing my self-hosted environment. It includes tested configurations, lessons learned, scripts, and best practices for running applications and infrastructure on my own hardware.

## Proxmox Nodes
This section documents each Proxmox node in the cluster, including hardware specifications, role, and hosted workloads.

| Node Name | CPU            | RAM  | Storage           | Role                  | Notes |
|-----------|---------------|------|-------------------|-----------------------|-------|
| sisyphus  | AMD 5700x | 32GB | 512GB nvme | Main compute + storage | Runs core services |

## Stack Overview
- **Server OS:** Proxmox VE
- **Networking:** Tailscale, Pi-hole, Reverse Proxy (Nginx/Traefik)
- **Storage:** ZFS / RAID with backups (my poor ass can't affor hdd's yet)

## Repository Structure
```
/node-name
├── apps/
├── security/
├── networking/
├── vm/
├── storage/
└── README.md
```
- **networking/** : VPN setup, DNS, firewall configurations  
- **vm/** : Proxmox, containerization, VM configurations  
- **app/** : Installation and tuning of self-hosted apps  
- **storage/** : Disk management, backups, ZFS guides/configs/documenatations  
- **security/** : Certificates, hardening, access control  

## License
This documentation is released under the [MIT License](LICENSE).
