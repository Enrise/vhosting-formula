# Install vanilla webstack with configured webserver
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}

include:
  - {{ webserver }}
