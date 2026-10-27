{% set user = salt['pillar.get']('morgh:dom0_user', 'shotor') %}

/usr/local/bin/morgh-appmenus:
  file.managed:
    - source: salt://shotor/dom0/files/appmenus
    - mode: '0755'

morgh-appmenus:
  cmd.run:
    - name: /usr/local/bin/morgh-appmenus
    - runas: {{ user }}
    - require:
      - file: /usr/local/bin/morgh-appmenus
