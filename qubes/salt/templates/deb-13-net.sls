include:
  - shotor.terminal
  - shotor.network
  - shotor.network.tray
  - shotor.wireguard

network-packages:
  pkg.installed:
    - pkgs:
      - bind9-utils
      - lsd
      - zoxide
      - htop
      - qubes-core-agent-network-manager
      - network-manager-gnome
      - wpasupplicant
      - firmware-iwlwifi
      - gnome-keyring
      - systemd-timesyncd
      - pciutils

