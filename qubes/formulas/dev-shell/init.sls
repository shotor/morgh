include:
  - shotor.terminal

dev-shell-packages:
  pkg.installed:
    - pkgs:
      - zsh
      - starship
      - zoxide
      - git
      - ca-certificates

omz-clone:
  cmd.run:
    - name: >-
        git -c http.proxy=http://127.0.0.1:8082 clone
        --depth=1 --single-branch --no-tags
        https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh
    - creates: /usr/share/oh-my-zsh/.git
    - require:
      - pkg: dev-shell-packages

omz-update:
  cmd.run:
    - name: |
        set -eu
        before=$(git rev-parse HEAD)
        git -c http.proxy=http://127.0.0.1:8082 pull --ff-only --no-rebase --no-tags >/dev/null
        after=$(git rev-parse HEAD)
        if [ "$before" = "$after" ]; then
          echo 'changed=no'
        else
          echo 'changed=yes'
        fi
    - cwd: /usr/share/oh-my-zsh
    - stateful: true
    - require:
      - cmd: omz-clone

dev-user-shell:
  user.present:
    - name: user
    - shell: /usr/bin/zsh
    - require:
      - pkg: dev-shell-packages
      - cmd: omz-update

dev-shell-locale:
  locale.present:
    - name: en_IE.UTF-8
    - require:
      - pkg: terminal-packages
