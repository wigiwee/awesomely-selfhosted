## Beszel Agent

This stack runs a Beszel agent with NVIDIA GPU monitoring support. It connects this host to a Beszel Hub and exposes host, Docker, disk, and GPU metrics.

| Service | URL | Purpose |
| --- | --- | --- |
| Beszel Agent | `http://<server-ip>:45876` | Monitoring agent for Beszel Hub |

## Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.
- A running Beszel Hub.
- Agent `KEY`, `TOKEN`, and `HUB_URL` values from Beszel Hub.

## Environment

Copy the example file:

```bash
cp .env.example .env
```

Edit `.env`:

```env
KEY=put-ur-key-here
HUB_URL=http://192.168.1.4:8090
TOKEN=token
```

## Data Paths

The compose file uses these host paths:

```text
/home/docker/data/beszel/beszel_agent_data
/home/docker/data/.beszel
/home/docker/hdd/.beszel
```

Create them if needed:

```bash
sudo mkdir -p /home/docker/data/beszel/beszel_agent_data
sudo mkdir -p /home/docker/data/.beszel
sudo mkdir -p /home/docker/hdd/.beszel
```

Adjust the volume paths in `compose.yml` if your storage layout is different.

## Start

```bash
docker compose up -d
```

Check the service:

```bash
docker compose ps
docker compose logs -f beszel-agent
```

## Hub Setup

In Beszel Hub, add this machine as a system and use:

```text
<server-ip>:45876
```

The agent uses host networking and listens on port `45876`.

If this host does not have an NVIDIA GPU, use the standard Beszel agent image and remove the GPU device reservation from `compose.yml`.

## Update

```bash
docker compose pull
docker compose up -d
docker image prune -a
```

## Backup

```bash
docker compose down
sudo tar -czf beszel-agent-backup.tar.gz /home/docker/data/beszel/beszel_agent_data
docker compose up -d
```
