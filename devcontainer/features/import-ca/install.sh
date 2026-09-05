#!/usr/bin/env bash
# import-ca: installs the `import-ca` tool and imports the certs/urls options at build
# time; the feature's entrypoint runs the tool again at every start, which picks up
# /usr/local/share/ca-certificates (a mount, usually)
set -euo pipefail

need=""
for tool in openssl curl update-ca-certificates; do
  command -v "$tool" >/dev/null || case "$tool" in
    update-ca-certificates) need="$need ca-certificates";;
    *) need="$need $tool";;
  esac
done
if [ -n "$need" ]; then
  echo "import-ca: installing$need"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  # shellcheck disable=SC2086
  apt-get install -y --no-install-recommends $need
  rm -rf /var/lib/apt/lists/*
fi

install -m 0755 "$(dirname "$0")/import-ca" /usr/local/bin/import-ca
mkdir -p /usr/local/share/ca-certificates

args=()
[ -z "${CERTS:-}" ] || args+=(--certs "$CERTS")
# shellcheck disable=SC2086
for url in ${URLS:-}; do args+=(--url "$url"); done
[ "${#args[@]}" -gt 0 ] || echo "import-ca: nothing to import at build time (certs, urls); /usr/local/share/ca-certificates is read at start"
import-ca "${args[@]}"
