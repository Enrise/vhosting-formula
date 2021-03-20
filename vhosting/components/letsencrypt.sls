## Installs letsencrypt certificates for each vhost
{% macro install_letsencrypt(salt, main_domain, aliases, config) %}
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}

# Request certificates
{% set domain_list = main_domain %}
{% if config.letsencrypt.extra_domains is defined %}
{% set domain_list = domain_list ~ ' -d ' ~ config.letsencrypt.extra_domains|join(' -d ') %}
{% endif %}
certificate-request-for-{{ main_domain }}:
  cmd.run:
    - name: certbot certonly --{{ webserver }} --non-interactive -d {{ domain_list }}
    - creates:
      - /etc/letsencrypt/live/{{ main_domain }}/fullchain.pem
      - /etc/letsencrypt/live/{{ main_domain }}/privkey.pem
    - require:
      - pkg: letsencrypt-client
      - service: {{ webserver }}

LE_cert_symlink_for_{{ main_domain }}:
  file.symlink:
    - name: /etc/ssl/certs/{{ config.cert }}
    - target: /etc/letsencrypt/live/{{ main_domain }}/fullchain.pem
LE_key_symlink_for_{{ main_domain }}:
  file.symlink:
    - name: /etc/ssl/private/{{ config.key }}
    - target: /etc/letsencrypt/live/{{ main_domain }}/privkey.pem

{% endmacro %}
