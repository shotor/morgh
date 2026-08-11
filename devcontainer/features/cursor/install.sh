#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Cursor feature install ==="
echo "Running as: $(whoami)"

if [[ -n "${CURSOR_API_KEY:-}" ]]; then
  echo "CURSOR_API_KEY is available during feature install"
  echo "CURSOR_API_KEY length: ${#CURSOR_API_KEY}"
else
  echo "CURSOR_API_KEY is NOT available during feature install"
fi

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  jq

rm -rf /var/lib/apt/lists/*

# Install Cursor Agent.
su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; curl -fsS https://cursor.com/install | bash"

AGENT="$HOME/.local/bin/agent"
REAL_AGENT="$HOME/.local/bin/cursor-agent"

# Move the real agent so our wrapper can take its place.
mv "$AGENT" "$REAL_AGENT"

# Install agent wrapper.
install \
  -o "$USER" \
  -g "$USER" \
  -m 0755 \
  "$SCRIPT_DIR/agent-wrapper" \
  "$AGENT"

# Install authentication helper.
install \
  -o "$USER" \
  -g "$USER" \
  -m 0755 \
  "$SCRIPT_DIR/agent-auth" \
  "$HOME/.local/bin/agent-auth"
