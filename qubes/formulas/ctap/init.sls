ctap-packages:
  pkg.installed:
    - pkgs:
      - qubes-ctap: '>=2.0.8'

qubes-ctapproxy@sys-usb.service:
  service.dead:
    - enable: false
    - require:
      - pkg: ctap-packages
