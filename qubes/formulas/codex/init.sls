{% set version = '0.164.0' %}
{% set arch = 'aarch64' if grains['cpuarch'] in ['aarch64', 'arm64'] else 'x86_64' %}
{% set hashes = {
  'x86_64': '3ec55053109608d5038f7e50750f7d25f768dfd740fef071aa710e2559b63aac',
  'aarch64': '5918add6c7e9cf1e14a9af1b4c0f4bf1d24a43903faac26df5dc4c019ea91bd5'
} %}

codex-packages:
  pkg.installed:
    - pkgs:
      - curl
      - tar
      - gzip
      - bubblewrap
      - ca-certificates
      - git
      - acl
      - sudo

codex-download:
  cmd.run:
    - name: >-
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /var/cache/codex-package-{{ version }}-{{ arch }}.tar.gz
        https://github.com/openai/codex/releases/download/rust-v{{ version }}/codex-package-{{ arch }}-unknown-linux-musl.tar.gz
    - unless: echo '{{ hashes[arch] }}  /var/cache/codex-package-{{ version }}-{{ arch }}.tar.gz' | sha256sum --check --status
    - require:
      - pkg: codex-packages

codex-install:
  archive.extracted:
    - name: /opt/codex/{{ version }}
    - source: /var/cache/codex-package-{{ version }}-{{ arch }}.tar.gz
    - source_hash: sha256={{ hashes[arch] }}
    - archive_format: tar
    - enforce_toplevel: False
    - if_missing: /opt/codex/{{ version }}/codex-package.json
    - require:
      - cmd: codex-download

/usr/bin/codex:
  file.symlink:
    - target: /opt/codex/{{ version }}/bin/codex
    - require:
      - archive: codex-install

codex-package-check:
  cmd.run:
    - name: >-
        test -s /opt/codex/{{ version }}/codex-package.json &&
        test -d /opt/codex/{{ version }}/codex-resources &&
        test -x /opt/codex/{{ version }}/bin/codex-code-mode-host &&
        /usr/bin/codex --version
    - onchanges:
      - archive: codex-install
      - file: /usr/bin/codex

agent:
  user.present:
    - home: /home/agent
    - shell: /bin/bash
    - createhome: True
    - password_lock: True

work:
  group.present:
    - addusers:
      - user
      - agent
    - require:
      - user: agent

/srv/git:
  file.directory:
    - user: user
    - group: work
    - mode: '2770'
    - makedirs: True
    - require:
      - group: work

work-default-permissions:
  cmd.run:
    - name: setfacl -m d:u::rwx,d:g::rwx,d:m::rwx,d:o::--- /srv/git
    - unless: test "$(getfacl -cp /srv/git | sed -n '/^default:/p')" = "$(printf 'default:user::rwx\ndefault:group::rwx\ndefault:mask::rwx\ndefault:other::---')"
    - require:
      - pkg: codex-packages
      - file: /srv/git

work-git-trust:
  cmd.run:
    - name: git config --system --add safe.directory '/srv/git/*'
    - unless: git config --system --get-all safe.directory | grep -Fxq '/srv/git/*'
    - require:
      - pkg: codex-packages

/var/lib/codex-agent:
  file.directory:
    - user: agent
    - group: work
    - mode: '0700'
    - require:
      - user: agent
      - group: work

/etc/qubes-bind-dirs.d/50-agent.conf:
  file.managed:
    - contents: "binds+=( '/srv/git' '/var/lib/codex-agent' )\n"
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
    - require:
      - file: /srv/git
      - file: /var/lib/codex-agent

/etc/sudoers.d/zz-agent:
  file.managed:
    - contents: "agent ALL=(ALL:ALL) !ALL\n"
    - user: root
    - group: root
    - mode: '0440'
    - check_cmd: /usr/sbin/visudo -cf
    - require:
      - pkg: codex-packages
      - user: agent

/usr/bin/codexjail:
  file.managed:
    - source: salt://shotor/codex/files/codexjail
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: /usr/bin/codex
      - file: /etc/sudoers.d/zz-agent
      - file: /var/lib/codex-agent
      - cmd: work-default-permissions
