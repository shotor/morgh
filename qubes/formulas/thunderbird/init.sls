/etc/apt/keyrings/thunderbird.asc:
  file.managed:
    - source: salt://shotor/firefox/files/mozilla.asc
    - mode: '0644'
    - makedirs: true

/etc/apt/sources.list.d/thunderbird.sources:
  file.managed:
    - mode: '0644'
    - contents: |
        Types: deb
        URIs: https://packages.mozilla.org/apt
        Suites: thunderbird-deb
        Components: main
        Signed-By: /etc/apt/keyrings/thunderbird.asc
    - require:
      - file: /etc/apt/keyrings/thunderbird.asc

/etc/apt/preferences.d/thunderbird:
  file.managed:
    - mode: '0644'
    - contents: |
        Package: thunderbird thunderbird-l10n-*
        Pin: origin packages.mozilla.org
        Pin-Priority: 1000

mail-thunderbird:
  pkg.latest:
    - name: thunderbird
    - refresh: true
    - require:
      - file: /etc/apt/sources.list.d/thunderbird.sources
      - file: /etc/apt/preferences.d/thunderbird
      - pkg: terminal-packages
