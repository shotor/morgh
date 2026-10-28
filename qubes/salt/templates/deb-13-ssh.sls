{% from "shotor/ssh-agent/map.jinja" import ssh_clients %}
{% set backend_uid = salt['user.info']('user')['uid'] %}

include:
  - shotor.terminal
  - shotor.ssh-agent
  - shotor.ctap

ssh-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - zoxide
      - htop
      - vim
      - qubes-core-agent-passwordless-root
      - qubes-usb-proxy
      - openssh-client
      - util-linux
      - ssh-askpass-gnome
      - libfido2-1
      - libu2f-udev
      - fido2-tools
      - yubikey-manager
      - usbutils

/usr/lib/systemd/user/fido-agent@.service:
  file.managed:
    - source: salt://shotor/ssh-agent/files/fido-agent@.service
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - require:
      - pkg: ssh-packages

/usr/bin/fido-load:
  file.managed:
    - source: salt://shotor/ssh-agent/files/load
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - pkg: ssh-packages

/etc/qubes/rpc-config/fido.Agent:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        skip-service-descriptor=true

{% for qube in ssh_clients | sort %}
/etc/qubes-rpc/fido.Agent+{{ qube }}:
  file.symlink:
    - target: /run/user/{{ backend_uid }}/fido-agent-{{ qube }}/agent.sock
    - makedirs: true
{% endfor %}
