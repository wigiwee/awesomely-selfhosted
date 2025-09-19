#!/bin/sh -e

chown -R borg:borg /home/borg/repo
chmod 700 /home/borg/.ssh
exec /usr/sbin/sshd -D
