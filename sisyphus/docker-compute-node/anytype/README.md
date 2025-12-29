## Anytype - A personal knowledge base

### step 1 - clone github repo

```bash
git clone https://github.com/anyproto/any-sync-dockercompose.git
```

### step - 2 configure the application
edit following attributes in any-sync-dockercompose/.env.default file in the github repo

```bash
EXTERNAL_LISTEN_HOSTS="x.x.x.x x.x.x.x your.domain.name"
STORAGE_DIR="/home/docker/data/anytype/storage/."
```

### step - 3 deploy docker container
```bash
cd any-sync-dockercompose
make start
```

### step - 4 connect the client
copy etc/client.yml file to the client device 
and select the server to the self hosted and select client.yml file on the application while signing up/loggin in

**note** : as long as STORAGE_DIR contents are intact the application will store the state irrespective to the container removal migration