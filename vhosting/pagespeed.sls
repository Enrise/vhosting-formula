# Install pagespeed module
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}

{%- if webserver == 'nginx' %}
{%- set pkg_name = 'ngx_pagespeed' %}
{%- else %}
{%- set pkg_name = 'libapache2-mod-pagespeed' %}
{%- endif %}

# Install pagespeed module
pagespeed_module:
  pkg.installed:
    - name: {{ pkg_name }}
    - require_in:
      - pkg: {{ webserver }}
