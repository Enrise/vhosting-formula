# Include the appropriate webstack
{%- set webserver_edition = salt['pillar.get']('vhosting:server:webserver_edition', 'vanilla') %}
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}
{%- set install_phpfpm = salt['pillar.get']('vhosting:server:install_phpfpm', True) %}
{%- set webroot_base = salt['pillar.get']('vhosting:server:basedir', '/srv/http') %}

include:
  - .grains
  {% if webserver == 'nginx' and install_phpfpm == True -%}
  - phpfpm
  {% endif -%}  
  - .{{webserver_edition}}

# Create base root for vhosts
webroot_base:
  file.directory:
    - name: {{ webroot_base }}

# Ensure the custom-logs vhosting are being rotated
vhost_logrotate:
  file.managed:
    - name: /etc/logrotate.d/vhosts
    - source: {{ salt['pillar.get']('vhosting:server:logrotate_template', 'salt://vhosting/templates/logrotate.conf.jinja') }}
    - template: {{ salt['pillar.get']('vhosting:server:logrotate_template_type', 'jinja') }}
