#!/bin/sh
set -eu

# ---- server ----
# the arguments pick the job types, --enable-job per type
peertube-runner server "$@" &
pid=$!
trap 'kill -TERM "$pid"; wait "$pid"' TERM INT

# ---- registration ----
# once per instance: the runner token lands in the config on the volume, a restart finds it there
until peertube-runner list-registered >/dev/null 2>&1; do sleep 1; done
if ! peertube-runner list-registered | grep -qF "$PEERTUBE_URL"; then
  peertube-runner register --url "$PEERTUBE_URL" --registration-token "$(cat "$PEERTUBE_REGISTRATION_TOKEN_FILE")" --runner-name "$PEERTUBE_RUNNER_NAME"
fi

wait "$pid"
