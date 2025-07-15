## Beszel - Simple, lightweight server monitoring

follow this [tutorial](https://beszel.dev/guide/hub-installation#docker-or-podman)

### step - 1 deploy beszel-hub
```bash
cd beszel-hub
docker compose up -d
```

### step - 2 deploy beszel-agent
visit the port exposed port and click on ```+ add system```  and copy compose.yml file from there

### step - 3 (on the to be monitored servers/systems)
```bash
mkdir beszel-agent
cd beszel-agent
touch compose.yml
nano beszel.yml # pated the copied contents
```

### step - 4 deploy the beszel-agent 
```bash
docker compose up
```
