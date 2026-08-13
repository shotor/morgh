#!/bin/sh
set -eu

if ! sudo nerdctl-real info >/dev/null 2>&1; then
  sudo sh -c 'containerd >/var/log/containerd.log 2>&1 &'

  until sudo nerdctl-real info >/dev/null 2>&1; do
    sleep 0.05
  done
fi

exec sudo nerdctl-real "$@"
