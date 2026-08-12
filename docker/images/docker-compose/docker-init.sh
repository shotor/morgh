#!/bin/sh
set -e

dockerd \
  --host=unix:///var/run/docker.sock \
  --data-root=/var/lib/docker \
  --storage-driver=vfs &

docker_pid=$!

trap 'kill "$docker_pid" 2>/dev/null || true; wait "$docker_pid"' TERM INT

until docker info >/dev/null 2>&1; do
    kill -0 "$docker_pid" 2>/dev/null || exit 1
    sleep 1
done

cd /workspace
docker compose up -d

wait "$docker_pid"
