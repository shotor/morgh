{% set release = grains['id'] in ['tpl-deb-13-dev', 'tpl-deb-13-dvm'] %}
{% set firefox = 'firefox' if release else 'firefox-esr' %}
{% if release %}
include:
  - shotor.firefox.release
  - shotor.firefox.extensions
{% endif %}

common-firefox:
{% if release %}
  pkg.latest:
    - name: firefox
    - refresh: true
    - require:
      - file: /etc/apt/sources.list.d/mozilla.sources
      - file: /etc/apt/preferences.d/mozilla
{% else %}
  pkg.installed:
    - name: firefox-esr
{% endif %}

/usr/lib/{{ firefox }}/distribution/policies.json:
  file.managed:
    - source: salt://shotor/firefox/files/policies.json.jinja
    - template: jinja
    - mode: '0644'
    - makedirs: true
    - require:
      - pkg: common-firefox
{% if release %}
      - sls: shotor.firefox.extensions
{% endif %}

/etc/firefox/morgh-user.js:
  file.managed:
    - source: salt://shotor/morgh-dotfiles/firefox/.config/firefox/user.js
    - mode: '0644'
    - makedirs: true
    - require:
      - pkg: common-firefox

/usr/lib/{{ firefox }}/morgh.cfg:
  file.managed:
    - source: salt://shotor/firefox/files/morgh.cfg
    - mode: '0644'
    - require:
      - file: /etc/firefox/morgh-user.js

/usr/lib/{{ firefox }}/defaults/pref/morgh.js:
  file.managed:
    - source: salt://shotor/firefox/files/autoconfig.js
    - mode: '0644'
    - require:
      - file: /usr/lib/{{ firefox }}/morgh.cfg

{% if release %}
firefox-esr-removed:
  pkg.removed:
    - name: firefox-esr
    - require:
      - pkg: common-firefox
{% endif %}
