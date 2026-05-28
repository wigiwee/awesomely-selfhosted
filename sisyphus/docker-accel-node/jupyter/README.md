## Jupyter GPU

This stack builds and runs a Jupyter Notebook container with NVIDIA GPU access.

| Service | URL | Purpose |
| --- | --- | --- |
| Jupyter | `http://<server-ip>:9999` | Notebook workspace |

## Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.

## Workspace

The compose file mounts:

```text
./workspace -> /workspace
```

Create the local workspace directory:

```bash
mkdir -p workspace
```

## Start

Build and start the container:

```bash
docker compose up -d --build
```

View the token and logs:

```bash
docker compose logs -f jupyter
```

Open the URL shown in the logs, or visit:

```text
http://<server-ip>:9999
```

## Notes

- The image is built locally from `dockerfile`.
- The notebook runs as root inside the container.
- If the host has no NVIDIA GPU, remove the GPU reservation section from `compose.yml`.
