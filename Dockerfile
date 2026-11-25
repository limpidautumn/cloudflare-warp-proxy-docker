FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG TARGETVARIANT
ARG GOST_VERSION=3.3.3

COPY --chmod=0755 scripts/gost-url.sh /usr/local/bin/gost-url

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloudflare-warp.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp.gpg] https://pkg.cloudflareclient.com trixie main" \
        > /etc/apt/sources.list.d/cloudflare-warp.list \
    && apt-get update \
    && apt-get install -y cloudflare-warp \
    && curl -fsSLo /tmp/gost.tgz \
        "$(gost-url "$GOST_VERSION" "$TARGETARCH" "$TARGETVARIANT")" \
    && tar -xzf /tmp/gost.tgz -C /usr/local/bin gost \
    && rm -f /tmp/gost.tgz \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

EXPOSE 1080
ENTRYPOINT ["/entrypoint.sh"]
