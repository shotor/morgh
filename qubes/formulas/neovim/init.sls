{% set version = '0.12.6' %}
{% set arch = 'arm64' if grains['cpuarch'] in ['aarch64', 'arm64'] else 'x86_64' %}
{% set hashes = {
  'x86_64': '474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87',
  'arm64': '8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815'
} %}

neovim-packages:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - tar
      - gzip

neovim-download:
  cmd.run:
    - name: >-
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /var/cache/neovim-{{ version }}-{{ arch }}.tar.gz
        https://github.com/neovim/neovim/releases/download/v{{ version }}/nvim-linux-{{ arch }}.tar.gz
    - unless: echo '{{ hashes[arch] }}  /var/cache/neovim-{{ version }}-{{ arch }}.tar.gz' | sha256sum --check --status
    - require:
      - pkg: neovim-packages

neovim-install:
  archive.extracted:
    - name: /opt/neovim/{{ version }}
    - source: /var/cache/neovim-{{ version }}-{{ arch }}.tar.gz
    - source_hash: sha256={{ hashes[arch] }}
    - archive_format: tar
    - if_missing: /opt/neovim/{{ version }}/nvim-linux-{{ arch }}/bin/nvim
    - require:
      - cmd: neovim-download

/usr/bin/nvim:
  file.symlink:
    - target: /opt/neovim/{{ version }}/nvim-linux-{{ arch }}/bin/nvim
    - require:
      - archive: neovim-install
