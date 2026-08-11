#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl

mkdir -p /usr/share/keyrings

curl -fsSL https://xpra.org/xpra.asc \
  -o /usr/share/keyrings/xpra.asc

curl -fsSL \
  https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/trixie/xpra.sources \
  -o /etc/apt/sources.list.d/xpra.sources

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  dbus-x11 \
  xauth \
  xpra \
  xpra-x11

install -d /usr/local/share/xpra
install -m 755 post-start.sh /usr/local/share/xpra/post-start.sh

rm -rf /var/lib/apt/lists/*
