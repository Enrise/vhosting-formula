# Getting Started

The package only installs a webstack (configured as vanilla-nginx by default) when there are users with vhosts defined.

Same applies for databases, if there is no `mysql_database` key
underneath the users MySQL-server is not being installed.

The ‘username’ for DB-only has no effect (e.g. it doesn’t create) system
users since we won’t need them and is only to allow for easy grouping.

Only one webstack is possible at the time, but multiple databases are
possible (e.g. MySQL and PostgreSQL). Depending on the needs you could
only use one or more of the components (vhosts, mysql\_databases,
cronjobs etc) or all. The installer automatically takes care of the
installation of the necessary components to get this to work.
