#!/bin/sh
set -eu

SOCKET="/run/containerd/containerd.sock"
LOG="/var/log/containerd.log"

if [ ! -S "$SOCKET" ]; then
  sudo sh -c "containerd >'$LOG' 2>&1 &"

  attempts=0

  while [ ! -S "$SOCKET" ]; do
    attempts=$((attempts + 1))

    if [ "$attempts" -ge 200 ]; then
      echo "Error: containerd failed to start." >&2
      echo "Check $LOG for details." >&2
      exit 1
    fi

    sleep 0.05
  done
fi

exec sudo nerdctl-real "$@"
