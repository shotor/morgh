{% set clients = salt['pillar.get']('keepassxc:clients', {}) %}
{% if clients is not mapping %}
{{ raise('keepassxc:clients must map client VM names to vault VM names.') }}
{% endif %}
{% for client, vault in clients.items() %}
{% for name in [client, vault] %}
{% if name is not string or (name | regex_match('^[A-Za-z][A-Za-z0-9_-]{0,30}$')) is none or name == 'dom0' %}
{{ raise('Invalid VM name in keepassxc:clients.') }}
{% endif %}
{% endfor %}
{% if client == vault %}
{{ raise('KeePassXC client and vault must be different VMs.') }}
{% endif %}
{% endfor %}

/etc/qubes/policy.d/30-keepassxc.policy:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
{% for client, vault in clients | dictsort %}
        keepassxc.Browser + {{ client }} @default allow target={{ vault }} user=user
{% endfor %}
        keepassxc.Browser * @anyvm @anyvm deny
