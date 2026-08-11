#!/usr/bin/env bash
set -euo pipefail

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  build-essential \
  clang \
  cmake \
  gdb \
  libegl1-mesa-dev \
  libgl1-mesa-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-dev \
  libxcb-cursor0 \
  lld \
  ninja-build \
  pkg-config \
  qt6-base-dev \
  qt6-base-dev-tools \
  qt6-declarative-dev \
  qt6-declarative-dev-tools \
  qt6-wayland \
  qml6-module-qtqml-workerscript \
  qml6-module-qtquick \
  qml6-module-qtquick-controls \
  qml6-module-qtquick-dialogs \
  qml6-module-qtquick-layouts \
  qml6-module-qtquick-templates \
  qml6-module-qtquick-window

rm -rf /var/lib/apt/lists/*
