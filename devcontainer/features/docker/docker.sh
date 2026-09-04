#!/bin/sh
set -eu

DOCKER=/usr/bin/docker
LOG="/var/log/dockerd.log"

if ! "$DOCKER" info >/dev/null 2>&1; then
  # fully detached: a daemon that keeps the session's stdin would hold a non-interactive
  # `ssh host docker ...` open forever
  sudo sh -c "setsid dockerd >'$LOG' 2>&1 </dev/null &"

  attempts=0

  while ! "$DOCKER" info >/dev/null 2>&1; do
    attempts=$((attempts + 1))

    if [ "$attempts" -ge 200 ]; then
      echo "Error: dockerd failed to start." >&2
      echo "Check $LOG for details." >&2
      exit 1
    fi

    sleep 0.05
  done
fi

exec "$DOCKER" "$@"
