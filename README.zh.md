# cloudflare-warp-proxy-docker

通过 Cloudflare WARP 全隧道（Traffic and DNS, UDP）提供 HTTP/HTTPS/SOCKS5 代理的 Docker 镜像。

## 使用须知

- 使用本项目即表示你已知悉并同意：必须遵守所在国家/地区的法律法规、监管要求及所在网络的管理政策；不得在未经授权的情况下绕过任何访问控制，包括但不限于网络监管/审查、企业或学校网络策略、地域限制等；不得用于违法侵权、攻击欺诈、公开开放代理或转售；使用者对通过本项目产生的全部流量和行为自行承担责任。
- 使用前请阅读 [Cloudflare WARP client](https://developers.cloudflare.com/warp-client/) 的 [隐私政策 (Privacy Policy)](https://www.cloudflare.com/application/privacypolicy/) 及 [服务条款 (Terms of Service)](https://www.cloudflare.com/application/terms/)，确保知情并自行承担使用责任。

## 使用

```bash
docker compose build
docker compose up -d
```

服务默认工作在 `0.0.0.0:1080`。

客户端通过 HTTPS/SOCKS5 代理访问：

```bash
curl -x http://127.0.0.1:1080 https://www.cloudflare.com/cdn-cgi/trace
curl -x socks5h://127.0.0.1:1080 https://www.cloudflare.com/cdn-cgi/trace
```

### 构建镜像

```bash
docker compose build --build-arg APT_MIRROR=https://mirrors.ustc.edu.cn/debian
docker compose build --build-arg GOST_URL=https://example.com/gost_3.3.3_linux_amd64.tar.gz
```

- `APT_MIRROR`：Debian 软件源；留空使用默认源。
- `APT_SECURITY_MIRROR`：Debian security 源；留空时自动推导。
- `GOST_URL`：覆盖 gost 二进制文件下载地址。

### 运行容器

```bash
WARP_PORT=1080 docker compose up -d
```

- `WARP_PORT`：服务监听端口；留空时为 1080。

注意：
- 容器需要 `NET_ADMIN`。
- 重建容器会重新注册 WARP 设备。
- 代理无认证，默认监听全部网卡；仅建议在局域网或受信网络使用。

## 实现

WARP 自带的 Local Proxy 模式只提供 TCP 转发，不提供完整的 UDP 链路。

本项目让 WARP 客户端运行在 `mode warp` 全隧道模式：客户端请求先到 gost 的 1080 端口，由它统一处理 HTTP/HTTPS CONNECT 与 SOCKS5。容器流量经 CloudflareWARP 虚拟网卡交给 `warp-svc`，再以 MASQUE (QUIC/UDP 443) 加密发往 Cloudflare。DNS 也由 WARP 接管，随隧道一起转发。
