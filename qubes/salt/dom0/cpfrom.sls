{% set user = salt['pillar.get']('morgh:dom0_user', 'shotor') %}
{% set account = salt['user.info'](user) %}

{{ account['home'] }}/.local/bin/cpfrom:
  file.managed:
    - source: salt://shotor/dom0/files/cpfrom
    - user: {{ user }}
    - group: {{ salt['file.gid_to_group'](account['gid']) }}
    - mode: '0755'
    - makedirs: true
