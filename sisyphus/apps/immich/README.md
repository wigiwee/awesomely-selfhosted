## Immich - a free, open-source, self-hosted photo and video management platform 

follow this tutorial for setting up Immich on docker compse - [tutorial](https://immich.app/docs/install/docker-compose)

**note :** pull latest docker-compose.yml and .env file from the upstream github

**note :** i tried setting up a seperate partition for all the data of the container but automatically mounting that partition via fstab caused the vm to crash, so i manually added a script to be executed at runtime, follow the steps to enable the script

### step - 1
```bash
sudo touch /etc/rc.local

```

### step - 2 
```bash
sudo chmod 755 /etc/rc.local 
```

### step - 3 rc.local file content
```bash

#!/bin/sh -e
# This script is executed at the end of each multiuser runlevel 

/path/to/my/script-for-mounting-parition.sh  

exit 0

```
### step - 4 script-for-mounting-parition.sh
```bash
#!/bin/sh -e

mount /dev/sda /home/docker/data
```

### step - 5 
change the path to the UPLOAD_LOCATION in the .env file according to the mounting point