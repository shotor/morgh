{% set addons = ['ublock-origin', 'vimium-ff'] %}
{% if grains['id'] == 'tpl-deb-13-dev' %}
{% set addons = addons + ['multi-account-containers', 'containers-new-tab'] %}
{% endif %}

firefox-extension-tools:
  pkg.installed:
    - pkgs:
      - curl
      - ca-certificates

/usr/libexec/morgh/firefox-addon:
  file.managed:
    - source: salt://shotor/firefox/files/firefox-addon
    - mode: '0755'
    - makedirs: true

{% for addon in addons %}
firefox-addon-{{ addon }}:
  cmd.run:
    - name: /usr/libexec/morgh/firefox-addon {{ addon }}
    - stateful: true
    - require:
      - pkg: firefox-extension-tools
      - file: /usr/libexec/morgh/firefox-addon
{% endfor %}

/usr/lib/firefox/distribution/policies.json:
  file.managed:
    - source: salt://shotor/firefox/files/policies.json.jinja
    - template: jinja
    - mode: '0644'
    - makedirs: true
    - require:
      - pkg: common-firefox
{% for addon in addons %}
      - cmd: firefox-addon-{{ addon }}
{% endfor %}
