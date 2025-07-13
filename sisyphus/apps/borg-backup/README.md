## BorgBackup - a deduplicating backup program



### step - 1 setup a ssh key (borg.pub, borg) in current folder 
```bash
mkdir authorized_keys
cd authorized_keys
ssh-keygen -t ed25519
```

### step - 2
make chnges to the compose file for configuring host volumes mountpoints and host ports mapping

### step - 3 
```bash
docker compose up
```

### step - 4 setup a ssh server in the container
```bash
docker exec -it borg_container bash
apt install openssh-server
```
copy the private key to your client's ~/.ssh folder

### step - 4 setup a repo in the container
```bash
cd /home/borg/repo
mkdir repository1
borg init --encryption=repokey repository1
```

## step - 5 setup a remote client to do backups to the server
**note:** i use vorta as a borg gui client for borg
  
  ![vorta](/assets/borg-backup/01.png)


  ![vorta](/assets/borg-backup/02.png)
add source to the vorta from client machine and manage excluded items and take backup

**Connection closed by remote host. Is borg working on the server?** :
if you see this error make sure that the correct ssh private key is selected for the profile and make sure that ~/.ssh has 700 permission and ~/.ssh/config has 600 

check vorta logs : Settings/About -> About -> logs
