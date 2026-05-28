## Ollama

This stack runs an Ollama server with NVIDIA GPU access for local LLM inference.

| Service | URL | Purpose |
| --- | --- | --- |
| Ollama | `http://<server-ip>:11434` | Local model server and API |

## Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.

## Data Path

The compose file stores models and Ollama state here:

```text
/home/docker/data/ollama/ollama
```

Create the directory:

```bash
sudo mkdir -p /home/docker/data/ollama/ollama
```

## Start

From this directory:

```bash
docker compose up -d
```

Check the service:

```bash
docker compose ps
docker compose logs -f ollama-server
```

If the host has no NVIDIA GPU, remove the GPU reservation section from `compose.yml` before starting the stack.

## Models

Pull a model:

```bash
docker compose exec ollama-server ollama pull llama3.2
```

Run a quick prompt:

```bash
docker compose exec ollama-server ollama run llama3.2
```

List downloaded models:

```bash
docker compose exec ollama-server ollama list
```

## API Test

List available models:

```bash
curl http://<server-ip>:11434/api/tags
```

Generate a response:

```bash
curl http://<server-ip>:11434/api/generate \
  -d '{"model":"llama3.2","prompt":"Write a short haiku about self hosting.","stream":false}'
```

## Update

```bash
docker compose pull
docker compose up -d
docker image prune -a
```

## Backup

Stop the container before taking a full backup:

```bash
docker compose down
sudo tar -czf ollama-backup.tar.gz /home/docker/data/ollama/ollama
docker compose up -d
```

Model files can be large, so check available disk space before archiving.
