# Deal with vhosting-specific configs (other than vhosts)
{% from "vhosting/map.jinja" import webstack, webserver_edition, webserver with context %}
{% from "vhosting/lib.sls" import serialize %}
{%- set php_config = salt['pillar.get']('vhosting:server:config:php', {}) %}

{%- if php_config %}
php_config:
  file.managed:
    - name: {{ webstack.php_config_dir ~ '/zzz_custom.ini' }}
    - source: 'salt://vhosting/templates/php.ini.jinja'
    - template: jinja
    - context:
      config: {{ serialize(php_config) }}
    - watch_in:
      {%- if webserver == 'nginx' %}
      - service: php5-fpm
      {%- else %}
      - service: {{ webserver }}
      {% endif -%}
{%- endif %}
