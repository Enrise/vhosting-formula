###
# Testing: Apache @ ZendServer
###
vhosting:
  lookup:
    webstack: 'zendserver.apache'
    php_config_dir: '/usr/local/zend/etc/conf.d'

    webserver_config_dir: '/etc/apache2'
    sites_available: '/etc/apache2/sites-available'
    sites_enabled: '/etc/apache2/sites-enabled'
  server:
    webserver: apache
    webserver_edition: zendserver

# ZendServer settings
zendserver:
  version:
    zend: '8.5'
    php: '5.6'
    apache: '2.2' # Travis uses Ubuntu 12.04 so Apache 2.2

  # Which webserver to use, can either be apache or nginx
  webserver: apache
  bootstrap: False
