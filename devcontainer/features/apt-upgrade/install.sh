#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y --no-install-recommends dist-upgrade
apt-get -y autoremove

rm -rf /var/lib/apt/lists/*
