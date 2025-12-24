# nginx-edge-node
nginx edge node is a lxc container which has cloudflared as well as nginx install, this node receives traffic from the internet via cloudflared and forwards this traffic to nginx proxy server

### installing cloudflared
### 1. Install cloudflared inside the container
Run exactly the same steps you used earlier, but inside the container:
```bash
sudo mkdir -p —mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg \
sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' \
sudo tee /etc/apt/sources.list.d/cloudflared.list

sudo apt-get update
sudo apt-get install cloudflared
```
Verify:
```bash
cloudflared —version
```
### 2. Run tunnel login inside the container

```bash
cloudflared tunnel login
```
The credentials will be stored inside  /root/.cloudflared/cert.pem
### 3. Create a tunnel 
```bash
cloudflared tunnel create lxc-app
```
this creates:

`/root/.cloudflared/<TUNNEL-UUID>.json`
### 4. Create the config file
Cloudflared does not create this automatically.
```bash
mkdir -p /etc/cloudflared
nano /etc/cloudflared/config.yml
```
Example (HTTP service on port 8080):
```yaml
tunnel: <TUNNEL-UUID>
credentials-file: /root/.cloudflared/<TUNNEL-UUID>.json

ingress:
  - hostname: app.example.com
    service: http://localhost:8080
  - service: http_status:404
```
### 5. Attach DNS (once per hostname)
```bash
cloudflared tunnel route dns lxc-app app.example.com
```
### 6. Install and start the service
```bash 
cloudflared service install
systemctl enable cloudflared
systemctl start cloudflared

```
Verify:
```bash
systemctl status cloudflared
```
### List tunnels (recommended)
Run inside the LXC container:
```
cloudflared tunnel list
```
Example output:
```
textID                                   NAME 
7c9f3b9a-2f3d-4a6b-9f12-8c0d8a1b1234   lxc-app
```

## setting up nginx
### 1. install nginx
```bash
sudo apt install nginx
```
### 2. start and enable nginx
```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```
### 3. configure nginx
before copying the given nginx.conf file make changes to it like domain name, server addresses, etc
```bash
sudo cp ./nginx.conf /etc/nginx/nginx.conf
```
### 4. reload the nginx with new configuration
```bash
sudo nginx -s reload 
```

## setting up subdomain
### 1. add dns entry for new subdomain
configure the cloudflare dns to route subdomain traffic to the tunnel
```bash
cloudflared tunnel route dns <TUNNEL_NAME> immich.wigiwee.com
```
apparently only this command not works on its own and we have to configure cloudflare to reroute the traffic comming to subdomain to specified endpoint
for this go to cloudflare dashboard and go to  dns > record   and add a new entry for this subdomain like this
```
type:A
name:subdomain.domain.com
IPv4 : tunnel uuid
```
![01](/assets/cloudflare/01.png)
### 2. cloudflared ingress configuration
configure your tunnel to reroute incoming traffic for subdomain to a server
```yaml
tunnel: lxc-app
credentials-file: /etc/cloudflared/lxc-app.json

ingress:
  - hostname: immich.wigiwee.com
    service: http://localhost:80

  - hostname: wigiwee.com
    service: http://localhost:80

  - service: http_status:404
```
#### reload cloudflared
```bash 
cloudflared tunnel restart lxc-app
```
### 3. configre nginx (optional)
configure nginx to reroute traffic to subdomain server
```nginx
server {
    listen 80;
    server_name immich.wigiwee.com;

    client_max_body_size 0;

    location / {
        proxy_pass http://x.x.x.x:2283;

        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```