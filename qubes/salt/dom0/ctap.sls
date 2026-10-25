{% from "shotor/ctap/map.jinja" import browser_clients %}

ctap-dom0-packages:
  pkg.installed:
    - name: qubes-ctap-dom0
    - require:
      - file: /etc/qubes/policy.d/30-ctap.policy

/etc/qubes/policy.d/30-ctap.policy:
  file.managed:
    - user: root
    - group: root
    - mode: '0600'
    - makedirs: true
    - contents: |
{% for service in ['ctap.GetInfo', 'ctap.ClientPin', 'u2f.Authenticate', 'u2f.Register'] %}
{% for qube in browser_clients %}
        {{ service }} * {{ qube }} sys-fido allow user=root
{% endfor %}
        {{ service }} * @anyvm @anyvm deny
{% endfor %}
