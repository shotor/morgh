#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 || ${1-} == --help || ${1-} == -h ]]; then
  echo "Usage: $0 dom0|TARGET [TARGET ...]"
  echo "Example: $0 tpl-deb-13-net tpl-deb-13-vault-net"
  if [[ $# -eq 0 ]]; then exit 1; fi
  exit 0
fi

dom0=false
targets=()
for target in "$@"; do
  if [[ ! $target =~ ^[A-Za-z][A-Za-z0-9_-]{0,30}$ ]]; then
    echo "Invalid target name: $target" >&2
    exit 1
  fi
  if [[ $target == dom0 ]]; then
    dom0=true
  else
    targets+=("$target")
  fi
done

if "$dom0"; then
  sudo qubesctl state.highstate
fi

if (( ${#targets[@]} )); then
  target_list=$(IFS=,; echo "${targets[*]}")
  sudo qubesctl --skip-dom0 --show-output --targets="$target_list" state.highstate
fi
