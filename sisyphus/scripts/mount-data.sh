#!/bin/sh -e

mount /dev/sdb /home/docker/data
chown  docker:docker /home/docker/data -R
