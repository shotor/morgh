{% from "shotor/ssh-agent/map.jinja" import ssh_clients %}
/etc/qubes/policy.d/30-fido.policy:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
{% for qube in ssh_clients | sort %}
        fido.Agent +{{ qube }} {{ qube }} sys-fido allow
{% endfor %}
        fido.Agent * @anyvm @anyvm deny
