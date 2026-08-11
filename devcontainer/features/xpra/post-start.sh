#!/usr/bin/env bash
set -euo pipefail

xpra start :100 \
  --daemon=yes \
  --exit-with-children=no
