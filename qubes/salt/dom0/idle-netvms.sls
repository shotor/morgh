morgh-idle-netvms.timer:
  service.dead:
    - enable: false
    - onlyif: test -f /etc/systemd/system/morgh-idle-netvms.timer

morgh-idle-netvms.service:
  service.dead:
    - onlyif: test -f /etc/systemd/system/morgh-idle-netvms.service
    - require:
      - service: morgh-idle-netvms.timer

{% for path in [
  '/etc/systemd/system/morgh-idle-netvms.timer',
  '/etc/systemd/system/morgh-idle-netvms.service',
  '/usr/local/libexec/morgh-idle-netvms',
  '/etc/morgh/idle-netvms.json',
  '/run/morgh-idle-netvms',
] %}
{{ path }}:
  file.absent:
    - require:
      - service: morgh-idle-netvms.service
{% endfor %}

idle-netvms-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/morgh-idle-netvms.service
      - file: /etc/systemd/system/morgh-idle-netvms.timer
