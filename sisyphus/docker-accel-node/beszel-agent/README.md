## Beszel Agent

This stack runs a Beszel agent with NVIDIA GPU monitoring support. It connects this host to a Beszel hub and exposes host, Docker, disk, and GPU metrics.

| Service | URL | Purpose |
| --- | --- | --- |
| Beszel Agent | `http://<server-ip>:45876` | Monitoring agent for Beszel Hub |

### Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.
- A running Beszel Hub.
- Agent `KEY`, `TOKEN`, and `HUB_URL` values from your Beszel Hub.

The compose file uses host networking and requests NVIDIA device access:

```yaml
network_mode: host
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities:
            - utility
```

If this host does not have an NVIDIA GPU, use the standard Beszel agent image and remove the GPU device reservation from `compose.yml`.

### Step 1 - Create the environment file

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and set the values for your Beszel Hub:

```env
KEY=put-ur-key-here
HUB_URL=http://192.168.1.4:8090
TOKEN=token
```

### Step 2 - Create data directories

The compose file stores agent data and extra filesystem markers in these paths:

```text
/home/docker/data/beszel/beszel_agent_data
/home/docker/data/.beszel
/home/docker/hdd/.beszel
```

Create them if they do not already exist:

```bash
sudo mkdir -p /home/docker/data/beszel/beszel_agent_data
sudo mkdir -p /home/docker/data/.beszel
sudo mkdir -p /home/docker/hdd/.beszel
```

Adjust the volume paths in `compose.yml` if your storage layout is different.

### Step 3 - Start the agent

From this directory:

```bash
docker compose up -d
```

Check the container:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f beszel-agent
```

### Beszel Hub setup

In the Beszel Hub web UI, add this machine as a system and use:

```text
<server-ip>:45876
```

The agent listens on port `45876` because `LISTEN` is set in `compose.yml`.

### Updating

```bash
docker compose pull
docker compose up -d
```

Remove old unused images:

```bash
docker image prune -a
```

### Backup

Stop the container before making a full backup:

```bash
docker compose down
sudo tar -czf beszel-agent-backup.tar.gz /home/docker/data/beszel/beszel_agent_data
docker compose up -d
```

The backup contains the agent state stored under `/var/lib/beszel-agent`.

### Useful commands

```bash
docker compose restart
docker compose restart beszel-agent
docker compose logs -f
docker compose down
docker compose up -d
```
