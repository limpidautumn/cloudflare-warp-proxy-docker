#!/bin/sh
set -eu

# APT_MIRROR is the Debian archive base (e.g. https://mirrors.ustc.edu.cn/debian).
# APT_SECURITY_MIRROR is optional. If unset, it defaults to
# "${APT_MIRROR}-security" when APT_MIRROR ends in /debian, else to APT_MIRROR.
mirror=${1:-${APT_MIRROR:-}}
[ -n "$mirror" ] || exit 0

mirror=${mirror%/}
security=${2:-${APT_SECURITY_MIRROR:-}}
if [ -z "$security" ]; then
	case "$mirror" in
	*/debian) security="${mirror}-security" ;;
	*) security="$mirror" ;;
	esac
fi
security=${security%/}

# The slim base image has no CA bundle yet. apt still verifies the Debian
# Release signatures with the archive keyring, so this is bootstrap-only.
install_ca=0
if [ ! -f /etc/ssl/certs/ca-certificates.crt ]; then
	case "$mirror" in
	https://*)
		install_ca=1
		echo 'Acquire::https::Verify-Peer "false";' \
			>/etc/apt/apt.conf.d/99-mirror-bootstrap
		;;
	esac
fi

esc() { printf '%s' "$1" | sed 's/[&#\\]/\\&/g'; }
m=$(esc "$mirror")
s=$(esc "$security")

# Rewrite both deb822 (.sources) and classic (.list) sources. Use temporary
# markers so the security URL is not matched again by the main URL pattern.
for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.sources /etc/apt/sources.list.d/*.list; do
	[ -f "$f" ] || continue
	sed -i -E \
		-e 's#https?://(deb|security)\.debian\.org/debian-security#__APT_SEC__#g' \
		-e 's#https?://(deb|security)\.debian\.org/debian#__APT_MAIN__#g' \
		-e "s#__APT_SEC__#${s}#g" \
		-e "s#__APT_MAIN__#${m}#g" "$f"
done

# If the user specifies an HTTPS mirror and there is no CA, the CA package is
# installed and the temporary bootstrap overlay is removed.
if [ "$install_ca" = 1 ]; then
	apt-get update
	apt-get install -y --no-install-recommends ca-certificates
	rm -f /etc/apt/apt.conf.d/99-mirror-bootstrap
fi

echo "apt mirror: ${mirror} (security: ${security})"
