## Wger - community-driven free and open-source fitness tracker.

### step 1 - pull upstream github repo
```bash
git clone https://github.com/wger-project/docker.git
```

### step 2 - pull upstream github repo
```bash
docker compose up 
```

### step 3 - configure docker compose
make changes to the ./docker/docker-compose.yml file for host volume mounting points and host port mapping
refer to provided compose.yml

### step 4 - configure docker compose
make chnages to the following attributes in ./docker/config/prod.env

```bash
SECRET_KEY=your-secret-key
SIGNING_KEY=your-second-secret-key
TIME_ZONE=Asia/Kolkata
TZ=Asia/Kolkata
CSRF_TRUSTED_ORIGINS=https://your-ip:your-port,https://your.domain.name
```

### step 5 
if you are not using default configuration docker volumes
then make sure that the mounted data partition/dir has correct permissions/owners

run this commands to make sure
```bash
sudo chmod 777 data/wger -R
sudo chown user:user data/wger -R
```

### step 6 - start the container stack
``` bash
cd docker
docker compose up
```

### step 7 
visit configured port via http on the browser client and 
download the wger app from play store

### Screenshots

![0](/assets/wger/01.png)

![2](/assets/wger/02.png)