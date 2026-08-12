#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"

su -s /bin/sh "$USER" -c \
  "HOME='$HOME' '$HOME/.local/bin/mise' use -g python@3.14"
