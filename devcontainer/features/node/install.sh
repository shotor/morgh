#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"

su -s /bin/sh "$USER" -c \
  "HOME='$HOME' '$HOME/.local/bin/mise' use -g node@24"

NODE_DIR="$(
  su -s /bin/sh "$USER" -c \
    "export HOME='$HOME'; '$HOME/.local/bin/mise' where node"
)"

ln -sf "$NODE_DIR/bin/node" /usr/local/bin/node
ln -sf "$NODE_DIR/bin/npm" /usr/local/bin/npm
ln -sf "$NODE_DIR/bin/npx" /usr/local/bin/npx
