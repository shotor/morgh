include:
  - shotor.terminal

network-packages:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - qubes-core-agent-network-manager
      - network-manager-gnome
      - wpasupplicant
      - firmware-iwlwifi
      - gnome-keyring
      - systemd-timesyncd
      - pciutils

