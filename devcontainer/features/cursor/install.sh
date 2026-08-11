#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="/var/log/cursor-feature-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Cursor feature install ==="
echo "date: $(date -Iseconds)"
echo "running as: $(whoami)"
echo "USER: $USER"
echo "HOME: $HOME"
echo "SCRIPT_DIR: $SCRIPT_DIR"

echo
echo "=== feature contents ==="
ls -la "$SCRIPT_DIR"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  jq

rm -rf /var/lib/apt/lists/*

echo
echo "=== installing Cursor ==="

su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; curl -fsS https://cursor.com/install | bash"

echo
echo "=== bin after Cursor installer ==="
ls -la "$HOME/.local/bin"

echo
echo "=== installing agent wrapper ==="

rm -f "$HOME/.local/bin/agent"

install \
  -o "$USER" \
  -g "$USER" \
  -m 0755 \
  "$SCRIPT_DIR/agent-wrapper" \
  "$HOME/.local/bin/agent"

echo
echo "=== installing agent-auth ==="

install \
  -o "$USER" \
  -g "$USER" \
  -m 0755 \
  "$SCRIPT_DIR/agent-auth" \
  "$HOME/.local/bin/agent-auth"

echo
echo "=== final bin contents ==="
ls -la "$HOME/.local/bin"

echo
echo "=== installed files ==="
stat "$HOME/.local/bin/agent"
stat "$HOME/.local/bin/cursor-agent"
stat "$HOME/.local/bin/agent-auth"

echo
echo "=== Cursor feature install complete ==="
