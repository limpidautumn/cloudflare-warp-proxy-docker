# AGENTS.md

项目维护一个 docker 镜像。

对外提供 HTTP/HTTPS/SOCKS5 Proxy 服务。请求在内部通过 CloudflareWARP: Traffic and DNS (UDP) 转发。

## Dockerfile

构建一个包含 Cloudflare WARP 客户端和 gost 代理的轻量 Debian 镜像，用于通过 WARP 提供 SOCKS 代理服务。

维护时，确保逻辑最简。尽可能将各模块解耦，独立维护。使用 reteps/dockerfmt 格式化。

## docker-compose.yml

构建并运行代理容器。

- 启用 init，用于回收进程；
- 配置 NET_ADMIN，用于 WARP 建立隧道。

## scripts/gost-arch.sh

面对依赖 https://github.com/go-gost/gost，维护一个 {version,arch,arch-variant} -> Release URL 的映射。

需要维护 v3.0.0 至当前最新稳定版的所有版本。

维护时，确保逻辑最简、覆盖最全。使用 shfmt 格式化。

## scripts/apt-mirror.sh

维护一个脚本，用于将 Debian 默认 apt 源替换成用户指定的镜像源。若指定的镜像源为空，则保留默认源。若指定 HTTPS 源，一并处理首次引导的 CA 问题。

严禁在本机执行。

维护时，确保其逻辑最简、残留最小。使用 shfmt 格式化。

## README.md 及 README.zh.md

当前 README.md 是从 README.zh.md 翻译而来的。

当功能及使用方法出现变动，与 README 不一致时，请无条件询问用户是否同步更改 README 描述。优先修改 README.zh.md，随后交付用户审批。翻译为英文 README.md 时，请确保其严格精确描述 README.zh.md 的全部内容。
