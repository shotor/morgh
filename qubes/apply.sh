#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 || ${1-} == --help || ${1-} == -h ]]; then
  echo "Usage: $0 dom0|TARGET [TARGET ...]"
  echo "       $0 --template (or --templates): apply all Morgh templates, skip dom0"
  echo "Example: $0 tpl-deb-13-net tpl-deb-13-vault-net"
  if [[ $# -eq 0 ]]; then exit 1; fi
  exit 0
fi

if [[ ${1-} == --template || ${1-} == --templates ]]; then
  if (( $# != 1 )); then
    echo "Use --template on its own." >&2
    exit 1
  fi
  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  shopt -s nullglob
  template_states=("$script_dir"/salt/templates/*.sls)
  if (( ${#template_states[@]} == 0 )); then
    echo "No template states found." >&2
    exit 1
  fi
  set --
  for state in "${template_states[@]}"; do
    name=${state##*/}
    set -- "$@" "tpl-${name%.sls}"
  done
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
