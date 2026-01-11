#!/usr/bin/env bash

chmod +x /home/docker/awesomely-selfhosted/sisyphus/scripts/docker-actions/docker-actions.sh >> /var/log/docker-actions-setup.log 2>&1
ln -s /home/docker/awesomely-selfhosted/sisyphus/scripts/docker-actions/docker-actions.sh /usr/local/bin/docker-actions >> /var/log/docker-actions-setup.log 2>&1
docker-actions