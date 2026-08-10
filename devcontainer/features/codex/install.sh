#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl
rm -rf /var/lib/apt/lists/*

su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; export CODEX_NON_INTERACTIVE=true; curl -fsSL https://chatgpt.com/codex/install.sh | sh"
