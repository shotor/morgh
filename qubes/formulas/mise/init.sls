mise-repository-tools:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg

mise-repository-key:
  cmd.run:
    - name: >-
        install -d -m 0755 /usr/share/keyrings &&
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /var/cache/mise-repository.asc https://mise.jdx.dev/gpg-key.pub &&
        gpg --batch --yes --dearmor
        --output /usr/share/keyrings/mise-archive-keyring.gpg.tmp
        /var/cache/mise-repository.asc &&
        chmod 0644 /usr/share/keyrings/mise-archive-keyring.gpg.tmp &&
        mv /usr/share/keyrings/mise-archive-keyring.gpg.tmp
        /usr/share/keyrings/mise-archive-keyring.gpg
    - creates: /usr/share/keyrings/mise-archive-keyring.gpg
    - require:
      - pkg: mise-repository-tools

mise-repository:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/mise-archive-keyring.gpg] https://mise.jdx.dev/deb stable main
    - file: /etc/apt/sources.list.d/mise.list
    - require:
      - cmd: mise-repository-key

mise-package:
  pkg.installed:
    - name: mise
    - refresh: true
    - require:
      - pkgrepo: mise-repository
