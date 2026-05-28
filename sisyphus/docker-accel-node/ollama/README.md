## Ollama

This stack runs an Ollama server with NVIDIA GPU access for local LLM inference.

| Service | URL | Purpose |
| --- | --- | --- |
| Ollama | `http://<server-ip>:11434` | Local model server and API |

### Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.
- A data directory for Ollama models and configuration.

The compose file requests one NVIDIA GPU:

```yaml
deploy:
  resources:
    reservations:
      devices:
      - driver: nvidia
        count: 1
        capabilities: [gpu]
```

If the host has no NVIDIA GPU, remove the GPU reservation section from `compose.yml` before starting the stack.

### Step 1 - Create the data directory

The compose file stores Ollama data here:

```text
/home/docker/data/ollama/ollama
```

Create the directory:

```bash
sudo mkdir -p /home/docker/data/ollama/ollama
```

### Step 2 - Start the server

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
docker compose logs -f ollama-server
```

### Step 3 - Pull a model

Pull models inside the running container:

```bash
docker compose exec ollama-server ollama pull llama3.2
```

Run a quick test prompt:

```bash
docker compose exec ollama-server ollama run llama3.2
```

List downloaded models:

```bash
docker compose exec ollama-server ollama list
```

### API usage

The Ollama API is exposed on the host at:

```text
http://<server-ip>:11434
```

Test it from another machine on the network:

```bash
curl http://<server-ip>:11434/api/tags
```

Generate a response:

```bash
curl http://<server-ip>:11434/api/generate \
  -d '{"model":"llama3.2","prompt":"Write a short haiku about self hosting.","stream":false}'
```

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
sudo tar -czf ollama-backup.tar.gz /home/docker/data/ollama/ollama
docker compose up -d
```

The backup contains downloaded models and Ollama state. Model files can be large, so check available disk space before archiving.

### Useful commands

```bash
docker compose restart
docker compose restart ollama-server
docker compose logs -f
docker compose down
docker compose up -d
```
