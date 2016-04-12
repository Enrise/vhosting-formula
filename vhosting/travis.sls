# This file is only intended to be used on Travis-CI and should not be used standalone

# Requires salt-minion definition for mariadb
salt-minion:
  pkg.installed: []
  service.running: []
