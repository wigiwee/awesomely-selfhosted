#!/bin/sh -e

rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
