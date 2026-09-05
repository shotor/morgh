#!/usr/bin/env bash
set -euo pipefail

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg

install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
  -o /etc/apt/keyrings/packages.mozilla.org.asc
chmod 0644 /etc/apt/keyrings/packages.mozilla.org.asc

fingerprint="$(gpg --batch --show-keys --with-colons /etc/apt/keyrings/packages.mozilla.org.asc \
  | awk -F: '$1 == "fpr" { print $10; exit }')"
if [[ "$fingerprint" != "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3" ]]; then
  echo "Mozilla APT signing key fingerprint does not match." >&2
  exit 1
fi

cat > /etc/apt/sources.list.d/mozilla.sources <<'EOF'
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

cat > /etc/apt/preferences.d/mozilla-firefox <<'EOF'
Package: firefox firefox-l10n-*
Pin: origin packages.mozilla.org
Pin-Priority: 1000

Package: firefox
Pin: release o=Ubuntu
Pin-Priority: -1
EOF

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  firefox \
  fonts-dejavu-core

firefox --version

rm -rf /var/lib/apt/lists/*
