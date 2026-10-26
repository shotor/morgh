common-firefox:
  pkg.installed:
    - name: firefox-esr

/etc/firefox-esr/morgh-user.js:
  file.managed:
    - source: salt://shotor/morgh-dotfiles/firefox/.config/firefox/user.js
    - mode: '0644'
    - makedirs: true
    - require:
      - pkg: common-firefox

/usr/lib/firefox-esr/morgh.cfg:
  file.managed:
    - source: salt://shotor/firefox/files/morgh.cfg
    - mode: '0644'
    - require:
      - file: /etc/firefox-esr/morgh-user.js

/usr/lib/firefox-esr/defaults/pref/morgh.js:
  file.managed:
    - source: salt://shotor/firefox/files/autoconfig.js
    - mode: '0644'
    - require:
      - file: /usr/lib/firefox-esr/morgh.cfg
