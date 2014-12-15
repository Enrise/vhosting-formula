# Include the appropriate webstack
{%- set webserver_edition = salt['pillar.get']('vhosting:server:webserver_edition', 'vanilla') %}

include:
  - .{{webserver_edition}}
