include:
  - shotor.terminal
  - shotor.firefox
  - shotor.ctap.client
  - shotor.nextcloud

vault-net-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - ca-certificates
      - keepassxc
      - xdg-utils
