keepassxc-server-package:
  pkg.installed:
    - name: keepassxc

/etc/qubes-rpc/keepassxc.Browser:
  file.managed:
    - source: salt://shotor/keepassxc/files/server
    - mode: '0755'
    - makedirs: true
    - require:
      - pkg: keepassxc-server-package
