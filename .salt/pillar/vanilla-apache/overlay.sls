###
# Testing: Apache2 @ Vanilla
###
vhosting:
  lookup:
    ## For Vanilla
    webstack: 'vanilla.apache'
    php_config_dir: '/etc/php5/conf.d'
    ###

    webserver_config_dir: '/etc/apache2'
    sites_available: '/etc/apache2/sites-available'
    sites_enabled: '/etc/apache2/sites-enabled'
  server:
    webserver: apache
    edition: vanilla
