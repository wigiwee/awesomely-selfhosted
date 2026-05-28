## Immich

Immich is a self-hosted photo and video backup platform. This stack uses the upstream Immich Docker Compose layout with NVIDIA GPU support for the server and machine-learning containers.

| Service | URL | Purpose |
| --- | --- | --- |
| Immich | `http://<server-ip>:2283` | Photo and video library |

## Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver and NVIDIA Container Toolkit installed for GPU acceleration.
- Current Immich `docker-compose.yml` and `.env` files from the official release.

Reference: [Immich Docker Compose installation](https://immich.app/docs/install/docker-compose)

## Compose Files

This directory keeps `compose.yml.example` as a local reference. For production, pull the current release files from Immich:

```bash
curl -o compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
curl -o .env https://github.com/immich-app/immich/releases/latest/download/example.env
```

Then apply the local GPU and path changes you need.

## Storage

Set these paths in `.env`:

```env
UPLOAD_LOCATION=/home/docker/data/immich/upload
DB_DATA_LOCATION=/home/docker/data/immich/postgres
```

Create the directories:

```bash
sudo mkdir -p /home/docker/data/immich/upload
sudo mkdir -p /home/docker/data/immich/postgres
```

If media is stored on a separate mounted partition, make sure the partition is mounted before starting Immich.

## Start

```bash
docker compose up -d
```

Check logs:

```bash
docker compose logs -f immich-server
```

## Update Server

Use the included helper script:

```bash
./update-server.sh
```

Or run the commands manually:

```bash
docker compose pull
docker compose down
docker compose up -d
docker image prune -a
```

## Update Client

Update the Immich mobile app through the app store on each device.

## Backup

Back up the upload library, database data directory, and `.env` file. Stop the stack before taking a full filesystem backup:

```bash
docker compose down
sudo tar -czf immich-backup.tar.gz /home/docker/data/immich .env
docker compose up -d
```

## Screenshot

![Immich library](/assets/immich/01.png)
