include:
  - shotor.dns

tailscale-repository-tools:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl

tailscale-repository-key:
  cmd.run:
    - name: >-
        install -d -m 0755 /usr/share/keyrings &&
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /usr/share/keyrings/tailscale-archive-keyring.gpg.tmp
        https://pkgs.tailscale.com/stable/debian/trixie.noarmor.gpg &&
        chmod 0644 /usr/share/keyrings/tailscale-archive-keyring.gpg.tmp &&
        mv /usr/share/keyrings/tailscale-archive-keyring.gpg.tmp
        /usr/share/keyrings/tailscale-archive-keyring.gpg
    - creates: /usr/share/keyrings/tailscale-archive-keyring.gpg
    - require:
      - pkg: tailscale-repository-tools

tailscale-repository:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian trixie main
    - file: /etc/apt/sources.list.d/tailscale.list
    - require:
      - cmd: tailscale-repository-key

/etc/systemd/system/tailscaled.service.d/qubes.conf:
  file.managed:
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/tailscale
        Requires=systemd-resolved.service
        After=systemd-resolved.service
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true

tailscale-package:
  pkg.installed:
    - name: tailscale
    - require:
      - pkgrepo: tailscale-repository
      - file: /etc/systemd/system/tailscaled.service.d/qubes.conf

tailscale-systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/tailscaled.service.d/qubes.conf
      - pkg: tailscale-package

tailscaled:
  service.enabled:
    - require:
      - cmd: tailscale-systemd-reload
      - pkg: tailscale-package

/var/lib/tailscale:
  file.directory:
    - user: root
    - group: root
    - mode: '0700'
    - require:
      - pkg: tailscale-package

/etc/qubes-bind-dirs.d/60-tailscale.conf:
  file.managed:
    - contents: "binds+=( '/var/lib/tailscale' )\n"
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /var/lib/tailscale
