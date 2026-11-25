# AGENTS.md

项目维护一个 docker 镜像。

对外提供 HTTP/HTTPS/SOCKS5 Proxy 服务。请求在内部通过 CloudflareWARP: Traffic and DNS (UDP) 转发。

## Dockerfile

使用 reteps/dockerfmt 格式化。

## scripts/gost-arch.sh

面对依赖 https://github.com/go-gost/gost，维护一个 {version,arch,arch-variant} -> Release URL 的映射。

使用 shfmt 格式化。
