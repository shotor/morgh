{% set gateways = salt['pillar.get']('idle_netvms:gateways', []) %}
{% if gateways is string or gateways is mapping or gateways is not sequence %}
{{ raise('idle_netvms:gateways must be a list of VM names.') }}
{% endif %}
{% for name in gateways %}
{% if name is not string or (name | regex_match('^[A-Za-z][A-Za-z0-9_-]{0,30}$')) is none or name == 'dom0' %}
{{ raise('Invalid VM name in idle_netvms:gateways.') }}
{% endif %}
{% endfor %}

/etc/morgh/idle-netvms.json:
  file.managed:
    - contents: '{{ gateways | tojson }}'
    - mode: '0600'
    - makedirs: true

/usr/local/libexec/morgh-idle-netvms:
  file.managed:
    - source: salt://shotor/dom0/files/idle-netvms
    - mode: '0755'
    - makedirs: true

{% for unit in ['service', 'timer'] %}
/etc/systemd/system/morgh-idle-netvms.{{ unit }}:
  file.managed:
    - source: salt://shotor/dom0/files/idle-netvms.{{ unit }}
    - mode: '0644'
{% endfor %}

idle-netvms-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/morgh-idle-netvms.service
      - file: /etc/systemd/system/morgh-idle-netvms.timer

morgh-idle-netvms.timer:
  service.running:
    - enable: true
    - require:
      - cmd: idle-netvms-systemd-reload
      - file: /etc/morgh/idle-netvms.json
      - file: /usr/local/libexec/morgh-idle-netvms
