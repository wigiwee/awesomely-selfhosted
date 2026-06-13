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

## Object Detection with YOLOv9

This setup uses a YOLOv9 medium model exported to ONNX at `320x320`. The
TensorRT Frigate image automatically uses a supported NVIDIA GPU for the ONNX
detector.

The host needs NVIDIA driver version `545` or newer, a GPU with compute
capability `5.0` or newer, and the NVIDIA Container Toolkit. Confirm GPU
passthrough before configuring the model:

```bash
docker compose exec frigate nvidia-smi
```

Build a Frigate-compatible model:

```bash
docker build . --build-arg MODEL_SIZE=m --build-arg IMG_SIZE=320 --output . -f- <<'EOF'
FROM python:3.11 AS build
RUN apt-get update && apt-get install --no-install-recommends -y cmake libgl1 && rm -rf /var/lib/apt/lists/*
COPY --from=ghcr.io/astral-sh/uv:0.10.4 /uv /bin/
WORKDIR /yolov9
ADD https://github.com/WongKinYiu/yolov9.git .
RUN uv pip install --system -r requirements.txt
RUN uv pip install --system onnx==1.18.0 onnxruntime onnx-simplifier==0.4.* onnxscript
ARG MODEL_SIZE
ARG IMG_SIZE
ADD https://github.com/WongKinYiu/yolov9/releases/download/v0.1/yolov9-${MODEL_SIZE}-converted.pt yolov9-${MODEL_SIZE}.pt
RUN sed -i "s/ckpt = torch.load(attempt_download(w), map_location='cpu')/ckpt = torch.load(attempt_download(w), map_location='cpu', weights_only=False)/g" models/experimental.py
RUN python3 export.py --weights ./yolov9-${MODEL_SIZE}.pt --imgsz ${IMG_SIZE} --simplify --include onnx
FROM scratch
ARG MODEL_SIZE
ARG IMG_SIZE
COPY --from=build /yolov9/yolov9-${MODEL_SIZE}.onnx /yolov9-${MODEL_SIZE}-${IMG_SIZE}.onnx
EOF
```

Copy the generated model into Frigate's mapped config directory:

```bash
sudo mkdir -p /home/docker/data/frigate/config/model_cache
sudo cp yolov9-m-320.onnx /home/docker/data/frigate/config/model_cache/
```

Configure the ONNX detector and make sure the model dimensions match the
dimensions used during export:

```yaml
objects:
  track:
    - person
    - cat
    - car
    - bike

detectors:
  onnx:
    type: onnx

model:
  model_type: yolo-generic
  width: 320
  height: 320
  input_tensor: nchw
  input_dtype: float
  path: /config/model_cache/yolov9-m-320.onnx
  labelmap_path: /labelmap/coco-80.txt

detect:
  enabled: true
  fps: 5
```

Each camera that uses object detection also needs a stream with the `detect`
role and detection enabled:

```yaml
cameras:
  D1:
    ffmpeg:
      inputs:
        - path: rtsp://user:pass@192.168.1.xxx:554/cam/realmonitor?channel=1&subtype=1
          roles: [detect]
    detect:
      enabled: true
      width: 640
      height: 380
```

After restarting Frigate, check that the model loads without errors and review
the detector inference speed in the Frigate system metrics:

```bash
docker compose restart frigate
docker compose logs -f frigate
```

### Observed Performance

The following metrics were observed with the YOLOv9 medium model on an RTX
3060:

| Model resolution | GPU load | Inference time |
| --- | ---: | ---: |
| `640x640` | ~90% | ~17 ms |
| `320x320` | ~30% | ~6 ms |

Reducing the model resolution from `640x640` to `320x320` lowered the observed
GPU load by about 60 percentage points and inference time by about 65%. These
results are specific to the documented setup; camera count, detection FPS,
drivers, and other GPU workloads can affect performance. See the
[Frigate discussion](https://github.com/blakeblackshear/frigate/discussions/23454),
[object detector configuration](https://docs.frigate.video/configuration/object_detectors/),
and [NVIDIA GPU requirements](https://docs.frigate.video/frigate/hardware/#nvidia-gpus)
for details.

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
