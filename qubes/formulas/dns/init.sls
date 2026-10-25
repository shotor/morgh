dns-packages:
  pkg.installed:
    - name: systemd-resolved

/etc/qubes/protected-files.d/resolved:
  file.managed:
    - contents: /etc/resolv.conf
    - mode: '0644'
    - makedirs: true

/etc/resolv.conf:
  file.symlink:
    - target: /run/systemd/resolve/stub-resolv.conf
    - force: true
    - require:
      - pkg: dns-packages
      - file: /etc/qubes/protected-files.d/resolved

/etc/NetworkManager/conf.d/60-resolved.conf:
  file.managed:
    - contents: |
        [main]
        dns=systemd-resolved
        rc-manager=unmanaged
    - mode: '0644'
    - makedirs: true

/etc/systemd/resolved.conf.d/60-qubes.conf:
  file.managed:
    - contents: |
        [Resolve]
        FallbackDNS=
        LLMNR=no
        MulticastDNS=no
    - mode: '0644'
    - makedirs: true

/usr/libexec/morgh/dns-listener:
  file.managed:
    - source: salt://shotor/dns/files/dns-listener
    - mode: '0755'
    - makedirs: true

/usr/libexec/morgh/dns-forward:
  file.managed:
    - source: salt://shotor/dns/files/dns-forward
    - mode: '0755'
    - makedirs: true

/etc/systemd/system/systemd-resolved.service.d/qubes.conf:
  file.managed:
    - contents: |
        [Unit]
        After=qubes-sysinit.service
        [Service]
        ExecStartPre=+/usr/libexec/morgh/dns-listener
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /usr/libexec/morgh/dns-listener

/etc/systemd/system/qubes-iptables.service.d/dns.conf:
  file.managed:
    - contents: |
        [Service]
        ExecStartPost=/usr/libexec/morgh/dns-forward
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /usr/libexec/morgh/dns-forward

dns-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/systemd-resolved.service.d/qubes.conf
      - file: /etc/systemd/system/qubes-iptables.service.d/dns.conf

systemd-resolved:
  service.running:
    - enable: true
    - require:
      - pkg: dns-packages
      - cmd: dns-systemd-reload
      - file: /etc/resolv.conf
    - watch:
      - file: /etc/systemd/resolved.conf.d/60-qubes.conf
      - file: /etc/systemd/system/systemd-resolved.service.d/qubes.conf
      - file: /usr/libexec/morgh/dns-listener
