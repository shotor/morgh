include:
  - shotor.terminal

usb-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - zoxide
      - htop
      - qubes-core-agent-passwordless-root
      - qubes-usb-proxy
      - qubes-input-proxy-sender
      - usbutils
      - fido2-tools

/usr/lib/qubes/morgh-mouse-forwarding-allowed:
  file.absent: []

/etc/systemd/system/qubes-input-sender-mouse@.service.d/forwarding.conf:
  file.absent: []

usb-input-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/qubes-input-sender-mouse@.service.d/forwarding.conf
