###
# Testing: Nginx @ ZendServer
###
vhosting:
  lookup:
    php_config_dir: '/usr/local/zend/etc/conf.d'
  server:
    webserver: nginx
    webserver_edition: zendserver

phpfpm:
  lookup:
    config: /usr/local/zend/etc/fpm.d
    socket: /usr/local/zend/tmp

# ZendServer settings
zendserver:
  version:
    zend: '8.0'
    php: '5.6'

  # Which webserver to use, can either be apache or nginx
  webserver: nginx
  bootstrap: False
