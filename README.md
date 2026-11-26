# cloudflare-warp-proxy-docker

Cloudflare WARP full-tunnel SOCKS5/HTTP proxy, packaged as a Docker image.

<!-- Translated from README.zh.md; includes AI-generated content. -->

## Usage Notice

- By using this project, you acknowledge and agree that: you must comply with the laws, regulations, and regulatory requirements of your country/region, as well as the management policies of the network you are on; you must not circumvent any access control without authorization, including but not limited to network regulation/censorship, corporate or school network policies, regional restrictions, etc.; you must not use it for illegal or infringing activities, attacks or fraud, publicly open proxy services, or resale; you are solely responsible for all traffic and behavior generated through this project.
- Before use, please read the [Cloudflare WARP client](https://developers.cloudflare.com/warp-client/) [Privacy Policy](https://www.cloudflare.com/application/privacypolicy/) and [Terms of Service](https://www.cloudflare.com/application/terms/), and ensure that you are informed and bear responsibility for your own use.

## Usage

```bash
docker compose build
docker compose up -d
```

The service operates on `0.0.0.0:1080` by default.

Clients access it through the HTTPS/SOCKS5 proxy:

```bash
curl -x http://127.0.0.1:1080 https://www.cloudflare.com/cdn-cgi/trace
curl -x socks5h://127.0.0.1:1080 https://www.cloudflare.com/cdn-cgi/trace
```

### Building the Image

```bash
docker compose build --build-arg APT_MIRROR=https://mirrors.ustc.edu.cn/debian
docker compose build --build-arg GOST_URL=https://example.com/gost_3.3.3_linux_amd64.tar.gz
```

- `APT_MIRROR`: Debian software source; leave empty to use the default source.
- `APT_SECURITY_MIRROR`: Debian security source; derived automatically when empty.
- `GOST_URL`: overrides the download URL of the gost binary.

### Running the Container

```bash
WARP_PORT=1080 docker compose up -d
```

- `WARP_PORT`: the port the service listens on; 1080 when left empty.

Notes:

- The container requires `NET_ADMIN`.
- Recreating the container re-registers the WARP device.
- The proxy has no authentication and listens on all interfaces by default; it is recommended only for use on a LAN or trusted network.

## Implementation

WARP's built-in Local Proxy mode only provides TCP forwarding and does not provide a complete UDP path.

This project runs the WARP client in the `mode warp` full-tunnel mode: client requests first reach gost's port 1080, which handles HTTP/HTTPS CONNECT and SOCKS5 in a unified way. Container traffic is handed to `warp-svc` through the CloudflareWARP virtual network interface, and is then sent to Cloudflare encrypted with MASQUE (QUIC/UDP 443). DNS is also taken over by WARP and forwarded along with the tunnel.
