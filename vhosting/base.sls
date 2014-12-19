# Base setup
{%- set webroot_base = salt['pillar.get']('vhosting:server:basedir', '/srv/http') %}
{{ webroot_base }}:
  file.directory

# Logrotate
vhost_logrotate:
  file.managed:
    - name: /etc/logrotate.d/vhosts
    - source: {{ salt['pillar.get']('vhosting:server:logrotate_template', 'salt://vhosting/templates/template.conf') }}
    - template: {{ salt['pillar.get']('vhosting:server:logrotate_template_type', 'jinja') }}
