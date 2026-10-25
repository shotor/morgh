include:
  - shotor.ctap

qubes-ctapproxy@sys-fido.service:
  service.enabled:
    - require:
      - pkg: ctap-packages
      - service: qubes-ctapproxy@sys-usb.service
