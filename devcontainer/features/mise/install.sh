#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl
rm -rf /var/lib/apt/lists/*

su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; curl -fsSL https://mise.run | sh"

MISE_INIT_ZSH='eval "$(~/.local/bin/mise activate zsh)"'

touch "$ZSHRC"

grep -Fqx "$MISE_INIT_ZSH" "$ZSHRC" 2>/dev/null \
  || echo "$MISE_INIT_ZSH" >> "$ZSHRC"

MISE_INIT_BASH='eval "$(~/.local/bin/mise activate bash)"'

touch "$ZSHRC" "$BASHRC"

grep -Fqx "$MISE_INIT_BASH" "$BASHRC" 2>/dev/null \
  || echo "$MISE_INIT_BASH" >> "$BASHRC"

chown "$USER:$(id -gn "$USER")" "$ZSHRC" "$BASHRC"
