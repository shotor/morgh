{% set version = '2.0.6' %}
{% set arch = 'arm64' if grains['cpuarch'] in ['aarch64', 'arm64'] else 'amd64' %}
{% set hashes = {
  'amd64': '6351909200505681379d184be97059e63a812a0e557d48f1838b4b854e4f3395',
  'arm64': 'e91b9d038eaa03eb0d9c91c7372d927db9e7f2b132bdc0ae982350b93335f00c'
} %}
{% set package = '/var/cache/tpack_' ~ version ~ '_linux_' ~ arch ~ '.deb' %}

tpack-dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - ca-certificates
      - git
      - bash
      - tmux

tpack-download:
  cmd.run:
    - name: >-
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output {{ package }}
        https://github.com/tmuxpack/tpack/releases/download/v{{ version }}/tpack_{{ version }}_linux_{{ arch }}.deb
    - unless: echo '{{ hashes[arch] }}  {{ package }}' | sha256sum --check --status
    - require:
      - pkg: tpack-dependencies

tpack-install:
  cmd.run:
    - name: >-
        echo '{{ hashes[arch] }}  {{ package }}' | sha256sum --check &&
        dpkg --install {{ package }}
    - unless: test "$(dpkg-query -W -f='${Status} ${Version}' tpack 2>/dev/null)" = 'install ok installed {{ version }}'
    - require:
      - cmd: tpack-download
