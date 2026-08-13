#!/bin/sh
set -eu

if ! nerdctl-real info >/dev/null 2>&1; then
  containerd >/tmp/containerd.log 2>&1 &
  containerd_pid=$!

  until nerdctl-real info >/dev/null 2>&1; do
    if ! kill -0 "$containerd_pid" 2>/dev/null; then
      cat /tmp/containerd.log >&2
      exit 1
    fi
    sleep 0.05
  done
fi

exec nerdctl-real "$@"
