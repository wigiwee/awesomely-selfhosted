# docker-actions script

A small Bash utility to manage multiple Docker Compose services in a directory tree with a single command.

The script intelligently discovers Docker Compose files, starts or stops services, and avoids descending into subdirectories once a valid service is found.

## Usage

```bash
./docker-actions.sh <directory> <action>
```

`<directory>`: Root directory containing service folders (relative to the script)

`<action>`: up or down

## How to install
```
sudo chmod +x /home/docker/awesomely-selfhosted/sisyphus/scripts/docker-actions/docker-actions.sh
sudo ln -s /home/docker/awesomely-selfhosted/sisyphus/scripts/docker-actions/docker-actions.sh /usr/local/bin/docker-actions
```

## Example
```
docker-actions . up
```