#!/usr/bin/env bash
set -euo pipefail

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  iproute2 \
  iptables \
  wireguard-tools

curl -fsSL \
  https://github.com/3proxy/3proxy/releases/download/0.9.7/3proxy-0.9.7.x86_64.deb \
  -o /tmp/3proxy.deb

apt-get install -y /tmp/3proxy.deb

rm -f /tmp/3proxy.deb
rm -rf /var/lib/apt/lists/*
