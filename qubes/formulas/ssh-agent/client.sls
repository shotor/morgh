include:
  - shotor.ssh-agent

ssh-agent-client-packages:
  pkg.installed:
    - name: openssh-client

/usr/bin/fido-connect:
  file.managed:
    - source: salt://shotor/ssh-agent/files/connect
    - user: root
    - group: root
    - mode: '0755'

{% for unit in ['fido-forward.socket', 'fido-forward@.service'] %}
/usr/lib/systemd/user/{{ unit }}:
  file.managed:
    - source: salt://shotor/ssh-agent/files/{{ unit }}
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
{% endfor %}
