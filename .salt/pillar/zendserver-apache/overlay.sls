# Vhosting configuration overlay
vhosting:
  lookup:
    webstack: 'zendserver.apache'
    php_config_dir: '/usr/local/zend/etc/conf.d'

    webserver_config_dir: '/etc/apache2'    
    sites_available: '/etc/apache2/sites-available'
    sites_enabled: '/etc/apache2/sites-enabled'
  server:
    webserver: apache
    edition: zendserver

