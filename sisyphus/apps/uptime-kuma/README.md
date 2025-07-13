## Uptime kuma - A self-hosted server monitoring tool.

**note:** for some reason the uptime-kuma container won't let you set custom timezone, even if you specified it in the compose.yml file as TZ=Asia/Kolkata, and this wrong timezone affects the GUI server timeline 

so to over come this i have created a script which should be executed only once in the container when it is created

### step 1
make changes to the compose.yml file for host volume mounting points and host port mapping

make changes to the change-timezone.sh file if you are in other timezone than Asia/Kolkata

### step 2
```bash
docker compose up 
```
### step 3 - run the script
```
docker exec -it uptime-kuma bash
bash /scripts/change-timezone.sh
```

### step 4 
visit http://x.x.x.x:3001

![0](/assets/uptime-kuma/01.png)

![2](/assets/uptime-kuma/02.png)

![3](/assets/uptime-kuma/03.png)
