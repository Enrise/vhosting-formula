# Install letsencrypt client with config
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}

# Install certbot for automatic certificate renewal
letsencrypt-client:
  # this package repo is deprecated see https://launchpad.net/~certbot/+archive/ubuntu/certbot
  pkgrepo.absent:
    - ppa: certbot/certbot
  pkg.installed:
    - pkgs:
      - certbot
      - python3-certbot-{{ webserver }}
    - require:
      - pkgrepo: letsencrypt-client
      - pkg: {{ webserver }}

# Config
letsencrypt-config:
  file.managed:
    - name: /etc/letsencrypt/cli.ini
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: letsencrypt:config

# Service
letsencrypt-service-timer:
  service.running:
    - name: certbot.timer
    - enable: true
    - watch:
      - pkg: letsencrypt-client
