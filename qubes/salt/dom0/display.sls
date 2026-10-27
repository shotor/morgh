dom0-display-packages:
  pkg.installed:
    - pkgs:
      - autorandr
      - python3

/usr/local/bin/morgh-display-setup:
  file.managed:
    - source: salt://shotor/dom0/files/display-setup
    - mode: '0755'
    - require:
      - pkg: dom0-display-packages

autorandr:
  service.enabled:
    - require:
      - pkg: dom0-display-packages

dom0-display-udev-reload:
  cmd.run:
    - name: udevadm control --reload-rules
    - onchanges:
      - pkg: dom0-display-packages
