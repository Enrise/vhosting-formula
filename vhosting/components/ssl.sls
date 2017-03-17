# Deal with SSL
{% macro install_pair(salt, domain, aliases, config) %}
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}
{%- if 'letsencrypt' in config and config.letsencrypt == true %}
{% from "letsencrypt/map.jinja" import letsencrypt with context %}

### Test
# {{ domain|list + aliases }}
###

# Generate a list with domain + aliases
{%- set domainlist = [] %}
{%- do domainlist.append(domain) %}
{%- for alias in aliases %}
{%- do domainlist.append(alias) %}
{%- endfor %}

# Call LetsEncrypt to get an SSL certificate for {{ domain }} (aliases: {{ aliases|join(', ') }})
create-initial-cert-{{ domain }}:
  cmd.run:
    - unless: /usr/local/bin/check_letsencrypt_cert.sh {{ domainlist|join(' ') }}
    - name: {{
            letsencrypt.cli_install_dir
            }}/letsencrypt-auto --quiet -d {{ domainlist|join(' -d ') }} certonly --non-interactive --allow-subset-of-names
    - cwd: {{ letsencrypt.cli_install_dir }}
    - require:
      - file: letsencrypt-config
      - file: /usr/local/bin/check_letsencrypt_cert.sh

# Create the files based on the letsencrypt
ssl_cert_{{ domain }}:
  file.symlink:
    - name: /etc/ssl/certs/{{ config.cert }}
    - target: /etc/letsencrypt/live/{{ domain }}/fullchain.pem
    - watch_in:
      - service: {{ webserver }}
    - watch:
      - cmd: create-initial-cert-{{ domain }}

ssl_key_{{ domain }}:
  file.symlink:
    - name: /etc/ssl/private/{{ config.key }}
    - target: /etc/letsencrypt/live/{{ domain }}/privkey.pem
    - watch_in:
      - service: {{ webserver }}
    - watch:
      - cmd: create-initial-cert-{{ domain }}

# Register a cronjob to auto-renew this certificate every 60 days
letsencrypt-crontab-{{ domain }}:
  cron.present:
    - name: /usr/local/bin/renew_letsencrypt_cert.sh {{ domainlist|join(' ') }}
    - month: '*'
    - minute: random
    - hour: random
    - dayweek: '*'
    - identifier: letsencrypt-{{ domain }}
    - require:
      - cmd: create-initial-cert-{{ domain }}
      - file: /usr/local/bin/renew_letsencrypt_cert.sh
{%- else %}
# SSL Certificate: {{ config.cert }}
ssl_cert_{{ domain }}:
  file.managed:
    - name: /etc/ssl/certs/{{ config.cert }}
    - source: salt://ssl/{{ config.cert }}
    - watch_in:
      - service: {{ webserver }}

{%- if 'ca' in config %}
# SSL CA: {{ config.ca }}
ssl_chain_{{ domain }}:
  file.managed:
    - name: /etc/ssl/certs/{{ config.ca }}
    - source: salt://ssl/{{ config.ca }}
    - watch_in:
      - service: {{ webserver }}
{%- endif %}

# SSL key: {{ config.key }}
ssl_key_{{ domain }}:
  file.managed:
    - name: /etc/ssl/private/{{ config.key }}
    - source: salt://ssl/{{ config.key }}
    - watch_in:
      - service: {{ webserver }}

{%- endif %} #letsencrypt check
{% endmacro %}
