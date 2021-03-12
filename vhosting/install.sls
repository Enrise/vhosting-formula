#!py
def run():
    '''
    Install roles based on which features are configured
    '''
    packages = []

    for user, user_services in __salt__['pillar.get']('vhosting:users', {}).items():
      if 'vhost' in user_services:
        packages.append('vhosting.webstack')
      if 'mysql_database' in user_services:
        packages.append('mariadb')
        packages.append('mariadb.server.salt')

    if __salt__['pillar.get']('vhosting:server:letsencrypt_client', False) == True:
      packages.append('vhosting.letsencrypt')

    return {'include': packages}
