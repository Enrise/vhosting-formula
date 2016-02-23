# Deal with vhosting-specific configs (other than vhosts)
{% from "vhosting/map.jinja" import webstack, webserver_edition, webserver with context %}
{% from "vhosting/lib.sls" import serialize %}
{%- set php_config = salt['pillar.get']('vhosting:server:config:php', {}) %}
{%- set php_versions = salt['pillar.get']('phpfpm:php_versions', []) %}

{%- if php_config %}
{% if php_versions|length == 0 or salt['pillar.get']('vhosting:server:webserver_edition','vanilla') == 'zendserver' %}
# Vanilla Ubuntu 14.04 packages, see phpfpm formula README for more info.
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
      {% endif %}
{%- endif %}

{% for php_version in php_versions %}
# Alternative PHP versions as provided by Ondřej Surý, see phpfpm formula README for more info.
php_config-{{php_version}}:
  file.managed:
    - name: /etc/php/{{php_version}}/fpm/conf.d/zzz_custom.ini
    - source: 'salt://vhosting/templates/php.ini.jinja'
    - template: jinja
    - context:
      config: {{ serialize(php_config) }}
    - watch_in:
      {%- if webserver == 'nginx' %}
      - service: php{{php_version}}-fpm
      {%- else %}
      - service: {{ webserver }}
      {% endif -%}

{% endfor %} # End 'for php_version in php_versions'

{% endif %} # End 'if php_config'
