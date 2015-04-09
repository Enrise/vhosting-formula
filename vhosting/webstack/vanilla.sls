# Install vanilla webstack with configured webserver
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}
{%- set install_phpfpm = salt['pillar.get']('vhosting:server:install_phpfpm', True) %}

include:
  - {{ webserver }}
  {% if webserver == 'nginx' and install_phpfpm == True -%}
  - phpfpm
  {% endif -%}
