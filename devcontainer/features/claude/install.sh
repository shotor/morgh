#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
USER_HOME="$(getent passwd "$USER" | cut -d: -f6)"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl

rm -rf /var/lib/apt/lists/*

su -s /bin/bash "$USER" -c \
    "HOME='$USER_HOME' curl -fsSL https://claude.ai/install.sh | bash"
