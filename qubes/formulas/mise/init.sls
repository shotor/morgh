mise-repository-tools:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - extrepo

mise-repository:
  cmd.run:
    - name: extrepo enable mise
    - env:
      - http_proxy: http://127.0.0.1:8082
      - https_proxy: http://127.0.0.1:8082
      - no_proxy: ''
    - unless: test -s /etc/apt/sources.list.d/extrepo_mise.sources
    - require:
      - pkg: mise-repository-tools

mise-package:
  pkg.installed:
    - name: mise
    - refresh: true
    - require:
      - cmd: mise-repository
