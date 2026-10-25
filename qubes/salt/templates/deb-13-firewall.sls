include:
  - shotor.terminal

firewall-packages:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - qubes-core-agent-dom0-updates
