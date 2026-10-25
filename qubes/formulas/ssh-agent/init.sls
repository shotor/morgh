{% from "shotor/ssh-agent/map.jinja" import ssh_clients %}

/etc/fido/clients:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true
    - clean: true
{% if ssh_clients %}
    - require:
{% for qube in ssh_clients | sort %}
      - file: /etc/fido/clients/{{ qube }}
{% endfor %}
{% endif %}

{% for qube in ssh_clients | sort %}
/etc/fido/clients/{{ qube }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: ''
{% endfor %}

{% for path, source, mode in [
  ('/usr/bin/fido-start', 'start', '0755'),
  ('/usr/bin/fido-socket', 'socket-path', '0755'),
  ('/etc/X11/Xsession.d/85fido', 'environment.sh', '0644'),
  ('/etc/profile.d/fido.sh', 'environment.sh', '0644'),
  ('/etc/xdg/autostart/fido.desktop', 'autostart.desktop', '0644')
] %}
{{ path }}:
  file.managed:
    - source: salt://shotor/ssh-agent/files/{{ source }}
    - user: root
    - group: root
    - mode: '{{ mode }}'
    - makedirs: true
{% endfor %}
