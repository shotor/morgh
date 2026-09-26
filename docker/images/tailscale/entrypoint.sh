#!/bin/sh
# the tun's segmentation offload goes off as soon as the interface exists, so the kernel segments forwarded TCP
# instead of the tun dropping what it was asked to cut: https://github.com/tailscale/tailscale/issues/16198
set -eu

(
  i=0
  while ! ip link show tailscale0 >/dev/null 2>&1; do
    i=$((i + 1))
    [ "$i" -ge 120 ] && exit 0
    sleep 1
  done
  ethtool -K tailscale0 tso off gso off || true
) &

exec /usr/local/bin/containerboot "$@"
