###
# Testing: Nginx @ ZendServer
###
vhosting:
  lookup:
    php_config_dir: '/usr/local/zend/etc/conf.d'
  server:
    webserver: nginx
    edition: zendserver

# ZendServer settings
zendserver:
  version:
    zend: '8.5'
    php: '5.6'

  # Which webserver to use, can either be apache or nginx
  webserver: nginx
  bootstrap: False
