# Install a webstack based on Zend Server
{%- set webserver = salt['pillar.get']('vhosting:server:webserver', 'nginx') %}
{%- set disable_webserver = salt['pillar.get']('vhosting:server:config:disable_webserver', False) %}
{%- set enable_zray = salt['pillar.get']('vhosting:server:config:zendserver:enable_zray', False) %}
{%- set php_versions = salt['pillar.get']('phpfpm:php_versions', []) %}

include:
  - zendserver
{%- if not disable_webserver %}
{%- if webserver == 'nginx' %}
  - {{ webserver }}.light
{%- else %}
  - {{ webserver }}
{%- endif %}
{%- endif %}

{%- if webserver == 'nginx' and not disable_webserver %}
{% if php_versions|length > 0 %}
# The PHP-FPM formula only creates these folders if only the "default" PHP stack
#  is being used, not if multiple co-exist (in combination with ZS).
/usr/local/zend/etc/fpm.d:
  file.directory:
    - require:
      - pkg: zendserver

/usr/local/zend/tmp:
  file.directory:
    - require:
      - pkg: zendserver
    - require_in:
      - file: /usr/local/zend/etc/fpm.d
{%- endif %}
{%- endif %}

# Zend-server is ... a service. This is not included in the Zendserver formula (yet)
#zend-server:
#  service.running:
#    - enable: True
#    - restart: True
#    - watch:
#      - pkg: zendserver
#    - require:
#      - pkg: zendserver

#{%- if disable_webserver %}
## Stop & disable the webserver
#extend:
#  {{ webserver }}:
#    service:
#      - disabled
#
#kill_webserver:
#  service.dead:
#    - name: {{ webserver }}
#
#php5-fpm:
#  service:
#    - disabled
#
#kill_fpm:
#  service.dead:
#    - name: php-fpm
#{%- endif %}

{%- if not enable_zray %}
# Disable ZRay
/usr/local/zend/etc/conf.d/zray.ini:
  file.replace:
    - pattern: 'zray.enable=1'
    - repl: 'zray.enable=0'
    - onlyif: test -e /usr/local/zend/etc/conf.d/zray.ini
    - watch_in:
      - service: zendserver
{%- for php_version in php_versions %}
      - service: php{{ php_version }}-fpm
{%- endfor %}
{%- endif %}
