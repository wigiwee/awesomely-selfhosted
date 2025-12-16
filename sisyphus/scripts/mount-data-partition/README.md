## Mount Data partition

mount-data.sh script is used to mount external data partition to docker vm, the name of the assigned volume to the vm might vary on each startup so this script uses the size of that partition to recognize that partition

note - make changes to the script according to the size of the partition

```bash
DEVICE=$(lsblk -dn -o NAME,SIZE | awk '$2=="250G" {print $1}' | head -n1)
```
### steps to automate script execution on startup

### step 1 - create a crontab job
```bash
sudo crontab -e
```
this will open a file editor, (preffered nano)

### step 2 - create the cronjob
```bash
@reboot /home/docker/awesomely-selfhosted/sisyphus/scripts/mount-data-partition/mount-data.sh >> /var/log/mount-data.log 2>&1
```
