#!/bin/sh
set -eu

# containerd is intentionally started on demand instead of running dockerd.
#
# `nerdctl-real info` also verifies that containerd is reachable. If it
# isn't, start containerd and wait for its socket to become usable.

if ! sudo nerdctl-real info >/dev/null 2>&1; then
  sudo sh -c 'containerd >/var/log/containerd.log 2>&1 &'

  # Don't wait forever if containerd fails to start.
  attempts=0

  until sudo nerdctl-real info >/dev/null 2>&1; do
    attempts=$((attempts + 1))

    if [ "$attempts" -ge 200 ]; then
      echo "Error: containerd failed to start." >&2
      echo "Check /var/log/containerd.log for details." >&2
      exit 1
    fi

    sleep 0.05
  done
fi

exec sudo nerdctl-real "$@"
