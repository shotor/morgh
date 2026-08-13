#!/bin/sh
set -eu

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This feature only supports Debian-based distributions."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

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

apt-get update
apt-get install -y --no-install-recommends \
  containerd.io

rm -rf /var/lib/apt/lists/*

NERDCTL_VERSION="2.3.5"

case "$(dpkg --print-architecture)" in
  amd64)
    nerdctl_arch="amd64"
    ;;
  arm64)
    nerdctl_arch="arm64"
    ;;
  *)
    echo "Unsupported architecture: $(dpkg --print-architecture)"
    exit 1
    ;;
esac

curl -fsSL \
  "https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${nerdctl_arch}.tar.gz" \
  | tar -xz -C /usr/local/bin nerdctl

mv /usr/local/bin/nerdctl /usr/local/bin/nerdctl-real

# Configure nerdctl.
#
# We use containerd's native snapshotter instead of overlayfs because this
# feature runs containerd inside the devcontainer. Nested overlayfs mounts
# may not be supported by the outer container environment.
install -d -m 0755 /etc/nerdctl
install -m 0644 "$(dirname "$0")/nerdctl.toml" \
  /etc/nerdctl/nerdctl.toml

# Provide Docker-compatible and nerdctl commands through our wrapper.
install -m 0755 "$(dirname "$0")/docker.sh" /usr/local/bin/docker
install -m 0755 "$(dirname "$0")/docker.sh" /usr/local/bin/nerdctl
