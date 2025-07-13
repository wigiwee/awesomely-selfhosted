#!/bin/sh -e

chown -R borg:borg /home/borg/repo
chmod 700 /home/borg/.ssh
chmod 600 /home/borg/borg
exec /usr/sbin/sshd -D
