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
  "export HOME='$HOME'; \
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
   | sh -s -- -y --default-toolchain stable"

su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; \
   '$HOME/.cargo/bin/rustup' component add rustfmt clippy"
