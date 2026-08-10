#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
ZSHRC="$HOME/.zshrc"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl
rm -rf /var/lib/apt/lists/*

su -s /bin/sh "$USER" -c \
  "HOME='$HOME' curl -fsSL https://mise.run | sh"

MISE_INIT='eval "$(~/.local/bin/mise activate zsh)"'

touch "$ZSHRC"

grep -Fqx "$MISE_INIT" "$ZSHRC" 2>/dev/null \
  || echo "$MISE_INIT" >> "$ZSHRC"

chown "$USER:$(id -gn "$USER")" "$ZSHRC"
