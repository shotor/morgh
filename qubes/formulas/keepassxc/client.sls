/usr/bin/keepassxc-remote:
  file.managed:
    - source: salt://shotor/keepassxc/files/client
    - mode: '0755'

/usr/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json:
  file.managed:
    - source: salt://shotor/keepassxc/files/native-host.json
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /usr/bin/keepassxc-remote
