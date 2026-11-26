# AGENTS.md

项目维护一个 docker 镜像。

对外提供 HTTP/HTTPS/SOCKS5 Proxy 服务。请求在内部通过 CloudflareWARP: Traffic and DNS (UDP) 转发。

## Dockerfile

使用 reteps/dockerfmt 格式化。

## scripts/gost-arch.sh

面对依赖 https://github.com/go-gost/gost，维护一个 {version,arch,arch-variant} -> Release URL 的映射。

使用 shfmt 格式化。

## scripts/apt-mirror.sh

维护一个脚本，用于将 Debian 默认 apt 源替换成用户指定的镜像源。

若指定的镜像源为空，则保留默认源。

若指定 HTTPS 源，一并处理首次引导的 CA 问题。
