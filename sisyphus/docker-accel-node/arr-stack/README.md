## Arr Stack

This stack runs media automation services for downloading, organizing, and serving a local media library.

| Service | URL | Purpose |
| --- | --- | --- |
| Prowlarr | `http://<server-ip>:9696` | Indexer manager |
| Sonarr | `http://<server-ip>:8989` | TV automation |
| Radarr | `http://<server-ip>:7878` | Movie automation |
| Lidarr | `http://<server-ip>:8686` | Music automation |
| qBittorrent | `http://<server-ip>:8080` | Torrent client |
| Jellyfin | `http://<server-ip>:8096` | Media server |
| Homarr | `http://<server-ip>:7575` | Dashboard |

## Prerequisites

- Docker and Docker Compose plugin installed.
- A fixed host path for stack data, downloads, and media.
- NVIDIA Container Toolkit installed if using Jellyfin GPU acceleration.

## Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Default values:

```env
ARRPATH=/home/docker/data/arr/
PUID=1000
PGID=1000
TZ=Asia/Kolkata
```

Keep the trailing slash in `ARRPATH`; the compose file joins paths like `${ARRPATH}Downloads`.

Use `id` to confirm the correct `PUID` and `PGID` for the user that should own downloaded files.

## Data Directories

Create the directories used by the compose file:

```bash
sudo mkdir -p /home/docker/data/arr/{Downloads,Prowlarr/config,Prowlarr/backup,Sonarr/config,Sonarr/backup,Sonarr/tvshows,Radarr/config,Radarr/backup,Radarr/movies,Lidarr/config,Lidarr/music,Homarr/configs,Homarr/icons,Homarr/data,Jellyfin/config,qbittorrent/config}
sudo chown -R 1000:1000 /home/docker/data/arr
```

If you changed `PUID` and `PGID`, use those values in the `chown` command.

## Start

```bash
docker compose up -d
```

Check the stack:

```bash
docker compose ps
docker compose logs -f sonarr
```

## qBittorrent

Open:

```text
http://<server-ip>:8080
```

Find the temporary login credentials in the logs:

```bash
docker compose logs qbittorrent
```

After logging in:

- change the default password
- set the default save path to `/downloads`

## Prowlarr

Open:

```text
http://<server-ip>:9696
```

Add indexers, then connect Prowlarr to the Arr apps:

| App | Docker host | Port |
| --- | --- | --- |
| Sonarr | `sonarr` | `8989` |
| Radarr | `radarr` | `7878` |
| Lidarr | `lidarr` | `8686` |

Find each API key under:

```text
Settings -> General -> Security -> API Key
```

## Sonarr, Radarr, and Lidarr

Use these root folders:

| App | Root folder |
| --- | --- |
| Sonarr | `/data/tvshows` |
| Radarr | `/data/movies` |
| Lidarr | `/data/musicfolder` |

Add qBittorrent as the download client:

| Setting | Value |
| --- | --- |
| Host | `qbittorrent` |
| Port | `8080` |
| Sonarr category | `tv` |
| Radarr category | `movies` |
| Lidarr category | `music` |

The shared download path is:

```text
/downloads
```

## Jellyfin

Open:

```text
http://<server-ip>:8096
```

Add libraries:

| Library | Path |
| --- | --- |
| Movies | `/data/Movies` |
| TV Shows | `/data/TVShows` |
| Music | `/data/Music` |

If Jellyfin fails on a host without NVIDIA support, remove the Jellyfin GPU environment and `deploy.resources.reservations.devices` sections from `compose.yml`, then recreate the service.

## Homarr

Open:

```text
http://<server-ip>:7575
```

Add shortcuts for the services in this stack.

## Update

```bash
docker compose pull
docker compose up -d
docker image prune -a
```

## Backup

Stop the stack before taking a full backup:

```bash
docker compose down
sudo tar -czf arr-stack-backup.tar.gz /home/docker/data/arr
docker compose up -d
```

At minimum, back up the service config directories under `Prowlarr`, `Sonarr`, `Radarr`, `Lidarr`, `Jellyfin`, `qbittorrent`, and `Homarr`.
