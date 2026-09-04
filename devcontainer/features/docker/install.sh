#!/bin/sh
set -eu

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This feature only supports Debian-based distributions."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

USER="${_REMOTE_USER}"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

. /etc/os-release

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: ${VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# dockerd has BuildKit built in; buildx and compose are cli plugins
apt-get update
apt-get install -y --no-install-recommends \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

rm -rf /var/lib/apt/lists/*

# the cli talks to the socket without sudo
usermod -aG docker "$USER"

# /usr/local/bin/docker shadows /usr/bin/docker: starts dockerd on first use. The
# storage driver is dockerd's own pick (overlay2 where it works, down its list to vfs
# where nested mounts are not allowed, e.g. inside microsandbox).
install -m 0755 "$(dirname "$0")/docker.sh" /usr/local/bin/docker
