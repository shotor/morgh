#!/usr/bin/env bash
set -e

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"

sudo -u "$USER" \
  HOME="$HOME" \
  mise use -g node@24
