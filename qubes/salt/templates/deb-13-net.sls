include:
  - shotor.terminal
  - shotor.network
  - shotor.wireguard

network-packages:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-network-manager
      - network-manager-gnome
      - wpasupplicant
      - firmware-iwlwifi
      - gnome-keyring
      - systemd-timesyncd
      - pciutils

