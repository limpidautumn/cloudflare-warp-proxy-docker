#!/bin/sh
# {version, arch, variant} -> gost release asset URL
set -eu

version="$1"
arch="${2:-$(dpkg --print-architecture)}"
variant="${3:-}"

if [ "$arch" = amd64 ] && [ "$variant" = v3 ]; then
	arch=amd64v3
fi
if [ "$arch" = arm ]; then
	arch="arm${variant:-v7}"
fi
if [ "$arch" = armhf ]; then
	arch=armv7
fi
if [ "$arch" = i386 ]; then
	arch=386
fi

printf 'https://github.com/go-gost/gost/releases/download/v%s/gost_%s_linux_%s.tar.gz\n' \
	"$version" "$version" "$arch"
