#!/bin/sh
set -eu

mkdir -p /dev/net
[ -e /dev/net/tun ] || mknod /dev/net/tun c 10 200

warp-svc &

until warp-cli --accept-tos status >/dev/null 2>&1; do
	sleep 1
done

warp-cli --accept-tos registration new >/dev/null 2>&1 || true
warp-cli --accept-tos mode warp
warp-cli --accept-tos connect

until warp-cli --accept-tos status | grep -qw Connected; do
	sleep 1
done

exec gost -L "auto://:1080"
