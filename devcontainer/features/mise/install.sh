#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"
ZSHRC="$HOME/.zshrc"

sudo -u "$USER" \
  HOME="$HOME" \
  sh -c 'curl https://mise.run | sh'

MISE_INIT='eval "$(~/.local/bin/mise activate zsh)"'

grep -Fqx "$MISE_INIT" "$ZSHRC" 2>/dev/null \
  || echo "$MISE_INIT" >> "$ZSHRC"

chown "$USER:$(id -gn "$USER")" "$ZSHRC"
