# cloudflare-warp-proxy-docker
Cloudflare WARP full-tunnel SOCKS5/HTTP proxy, packaged as a Docker image.

```bash
docker compose build
docker compose build --build-arg APT_MIRROR=https://mirrors.ustc.edu.cn/debian

docker compose up -d
WARP_PORT=1080 docker compose up -d
```
