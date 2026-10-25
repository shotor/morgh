#!/usr/bin/env bash
set -euo pipefail
shopt -s failglob
qubes_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo=$(dirname -- "$qubes_dir")
if [[ "$repo" != /srv/shotor/morgh ]]; then
  echo 'Copy or clone morgh to /srv/shotor/morgh in dom0 first.' >&2
  exit 1
fi
sources=("$qubes_dir"/formulas/* "$qubes_dir/salt/dom0" "$qubes_dir/salt/templates" "$repo/dotfiles" "$qubes_dir/salt/top.sls")
targets=()
for source in "${sources[@]}"; do
  if [[ ! -e "$source" ]]; then
    echo "Missing Salt source: $source. Copy the complete Morgh checkout first." >&2
    exit 1
  fi
  case "$source" in
    "$repo/dotfiles") name=morgh-dotfiles ;;
    "$qubes_dir/salt/top.sls") name=morgh.top ;;
    *) name=${source##*/} ;;
  esac
  target="/srv/salt/shotor/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Refusing to replace existing non-symlink: $target" >&2
    exit 1
  fi
  targets+=("$target")
done
sudo install -d /srv/salt/shotor
for index in "${!sources[@]}"; do
  sudo ln -sfnT "${sources[$index]}" "${targets[$index]}"
done
sudo qubesctl top.enable shotor.morgh
