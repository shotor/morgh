#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  jq

rm -rf /var/lib/apt/lists/*

# Install Cursor Agent as the remote user.
su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; curl -fsS https://cursor.com/install | bash"

AGENT="$HOME/.local/bin/agent"
REAL_AGENT="$HOME/.local/bin/cursor-agent"

# Preserve the real Cursor Agent executable.
mv "$AGENT" "$REAL_AGENT"

# Install our wrapper in its place.
install \
  -o "$USER" \
  -g "$USER" \
  -m 0755 \
  "$SCRIPT_DIR/agent-wrapper" \
  "$AGENT"
