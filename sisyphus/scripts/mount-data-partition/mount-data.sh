#!/bin/bash
set -e

MOUNTPOINT="/home/docker/data"

# Find the block device that has size ~250G
DEVICE=$(lsblk -dn -o NAME,SIZE | awk '$2=="250G" {print $1}' | head -n1)

if [ -z "$DEVICE" ]; then
    echo "no data device found"
    exit 1
fi

# Get the partition path (/dev/sdX)
DEV_PATH="/dev/$DEVICE"

# Create mountpoint if not exists
mkdir -p "$MOUNTPOINT"

# Mount it
mount "$DEV_PATH" "$MOUNTPOINT"

echo "Mounted $DEV_PATH to $MOUNTPOINT"
