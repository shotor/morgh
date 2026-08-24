#!/usr/bin/env bash
set -euo pipefail

USER="${_REMOTE_USER}"
HOME="$(getent passwd "$USER" | cut -d: -f6)"

su -s /bin/sh "$USER" -c \
  "export HOME='$HOME'; '$HOME/.local/bin/mise' use -g node@24"

NODE_DIR="$(
  su -s /bin/sh "$USER" -c \
    "export HOME='$HOME'; '$HOME/.local/bin/mise' where node"
)"

cat >/usr/local/bin/node <<EOF
#!/bin/sh
exec "$NODE_DIR/bin/node" "\$@"
EOF

cat >/usr/local/bin/npm <<EOF
#!/bin/sh
exec "$NODE_DIR/bin/npm" "\$@"
EOF

cat >/usr/local/bin/npx <<EOF
#!/bin/sh
exec "$NODE_DIR/bin/npx" "\$@"
EOF

chmod +x /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx

node --version
npm --version
npx --version
