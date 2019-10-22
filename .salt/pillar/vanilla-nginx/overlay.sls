###
# Testing: Nginx @ Vanilla
###
vhosting:
  server:
    webserver: nginx
    webserver_edition: vanilla

# PHP-FPM settings for more recent PHP
{%- set php_versions = ['7.3'] %}
phpfpm:
  php_versions:
  {% for version in php_versions %}
    - '{{version}}'
  {%- endfor %}
  modules:
  {% for version in php_versions %}
    - php{{version}}-mysql
  {%- endfor %}
