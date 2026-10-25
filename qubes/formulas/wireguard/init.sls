include:
  - shotor.dns

wireguard-packages:
  pkg.installed:
    - name: wireguard-tools

/etc/wireguard:
  file.directory:
    - user: root
    - group: root
    - mode: '0700'

/etc/qubes-bind-dirs.d/60-wireguard.conf:
  file.managed:
    - contents: "binds+=( '/etc/wireguard' )\n"
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /etc/wireguard

/usr/bin/wg-vpn:
  file.managed:
    - source: salt://shotor/wireguard/files/wg-vpn
    - mode: '0755'

/usr/libexec/morgh/wg-dns/resolvconf:
  file.managed:
    - source: salt://shotor/wireguard/files/resolvconf
    - mode: '0755'
    - makedirs: true

/usr/libexec/morgh/wg-autostart:
  file.absent

/etc/systemd/system/wg-vpn.service:
  file.absent

/etc/systemd/system/multi-user.target.wants/wg-vpn.service:
  file.absent

/etc/systemd/system/wg-quick@.service.d/dns.conf:
  file.managed:
    - contents: |
        [Unit]
        Requires=systemd-resolved.service
        After=systemd-resolved.service
        [Service]
        ExecStart=
        ExecStart=/usr/bin/wg-vpn up %i
        ExecStop=
        ExecStop=/usr/bin/wg-vpn down %i
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /usr/bin/wg-vpn
      - file: /usr/libexec/morgh/wg-dns/resolvconf
      - pkg: wireguard-packages

wireguard-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/wg-quick@.service.d/dns.conf
      - file: /etc/systemd/system/wg-vpn.service
      - file: /etc/systemd/system/multi-user.target.wants/wg-vpn.service
