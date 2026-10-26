include:
  - shotor.network.tray-theme

network-tray-icons:
  cmd.run:
    - name: /usr/libexec/morgh/tray-icons network
    - stateful: true
    - require:
      - pkg: network-packages
      - file: /usr/libexec/morgh/tray-icons

