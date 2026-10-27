/etc/apt/keyrings/mozilla.asc:
  file.managed:
    - source: salt://shotor/firefox/files/mozilla.asc
    - mode: '0644'
    - makedirs: true

/etc/apt/sources.list.d/mozilla.sources:
  file.managed:
    - contents: |
        Types: deb
        URIs: https://packages.mozilla.org/apt
        Suites: mozilla
        Components: main
        Signed-By: /etc/apt/keyrings/mozilla.asc
    - require:
      - file: /etc/apt/keyrings/mozilla.asc

/etc/apt/preferences.d/mozilla:
  file.managed:
    - contents: |
        Package: firefox firefox-l10n-*
        Pin: origin packages.mozilla.org
        Pin-Priority: 1000
