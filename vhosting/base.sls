{% from "vhosting/map.jinja" import webstack, webserver_edition, webserver with context -%}

# Base setup
{%- set webroot_base = salt['pillar.get']('vhosting:server:basedir', '/srv/http') %}
{{ webroot_base }}:
  file.directory

# Logrotate @todo: template
vhost_logrotate:
  file.managed:
    - name: /etc/logrotate.d/vhosts
    - source: salt://logrotate/template.conf
    - template: jinja
