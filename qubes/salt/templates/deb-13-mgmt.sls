wezterm-removed:
  pkg.removed:
    - name: wezterm

/etc/apt/sources.list.d/wezterm.list:
  file.absent

mgmt-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - zoxide
      - htop
      - qubes-core-agent-passwordless-root
      - qubes-mgmt-salt-vm-connector
      
