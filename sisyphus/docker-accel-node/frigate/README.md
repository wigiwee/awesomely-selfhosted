## Frigate

Frigate is an NVR with object detection. This setup uses the TensorRT image with NVIDIA GPU acceleration.

| Service | URL / Port | Purpose |
| --- | --- | --- |
| Frigate UI | `https://<server-ip>:8971` | Web UI |
| Frigate internal UI | `http://<server-ip>:5000` | Unauthenticated internal access |
| RTSP | `<server-ip>:8554` | Restreamed RTSP feeds |
| WebRTC | `<server-ip>:8555` | WebRTC TCP/UDP |

## Prerequisites

- Docker and Docker Compose plugin installed.
- NVIDIA driver installed on the host.
- NVIDIA Container Toolkit installed and configured for Docker.
- Camera RTSP URLs and credentials.
- Optional MQTT server if MQTT events are needed.

## Setup

Copy the example compose file:

```bash
cp compose.yml.example compose.yml
```

Review and update:

- camera credentials in `compose.yml`
- host paths for config and recordings
- GPU reservation settings
- `shm_size` based on camera count and resolution

Create the host paths used by the example:

```bash
sudo mkdir -p /home/docker/data/frigate/config
sudo mkdir -p /home/docker/hdd/wd-video/storage
```

Place `config.yaml` in the mapped config directory:

```bash
sudo cp config.yaml /home/docker/data/frigate/config/config.yml
```

## Configure Cameras

Edit camera entries in `config.yaml` or `/home/docker/data/frigate/config/config.yml`:

```yaml
cameras:
  D1:
    ffmpeg:
      inputs:
        - path: rtsp://user:pass@192.168.1.xxx:554/cam/realmonitor?channel=1&subtype=0
          roles: [record]
```

Do not leave default passwords or placeholder camera IPs in production.

## Start

```bash
docker compose up -d
```

Check logs:

```bash
docker compose logs -f frigate
```

## Notes

- Port `5000` is unauthenticated in the example and should stay private.
- If the host has no NVIDIA GPU, use a non-TensorRT Frigate image and remove the GPU reservation.
- The sample config includes person detection, zones, recording retention, and notification placeholders.
