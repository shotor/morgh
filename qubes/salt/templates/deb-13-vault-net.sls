include:
  - shotor.terminal
  - shotor.firefox
  - shotor.ctap.client
  - shotor.nextcloud
  - shotor.nextcloud.tray

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
