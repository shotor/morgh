include:
  - shotor.terminal
  - shotor.firefox
  - shotor.ctap.client
  - shotor.nextcloud
  - shotor.nextcloud.tray
  - shotor.keepassxc.server

vault-net-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - zoxide
      - htop
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - ca-certificates
      - keepassxc
      - xdg-utils
