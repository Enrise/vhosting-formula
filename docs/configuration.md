# Configuration

## Server
The `server` part of the Pillar data contains which edition of webserver
(vanilla or zendserver) and which webserver (apache or nginx) should be
used.

```yaml
vhosting:
  server:
    webserver: nginx
    edition: vanilla
```

> **note**
>
> If `zendserver` is being configured as edition this formula should be available on your Salt fileserver and configured as well.
>
>    This does duplicate the webserver part since this particular
>     formula only reads its own information. If the formula is not
>     available it cannot install ZendServer (and components) and if the
>     Pillar data is missing it will install it with default values
>     which may differ from your requirements.

> If `letsencrypt` is being used, the official `letsencrypt` formula should be installed as well.

### Users

A user is only created when a ‘vhost’ is set, since this the only reason
(currently) why a user would be needed.

For users individual flags can be set:

**deploy\_structure**
>   Create a `data` and a `releases` folder. The webroot is a symlinked
>    to `../releases/current` unless the vhost is set to use ‘public’
>    (more about this later)

### Vhosts
If at least one `vhost` key is specified in the user-tree of the
vhosting pillar it will automatically install the configured webstack.

Vhosts depend on users. A user will be created automatically and will be
used for all of the domains that belong to this user.

The minimal configuration for a vhost is:

```yaml
vhosting:
  users:
    example:
      vhost:
        example.com: {}
```

> **note**
>
> An empty dictionary is mandatory if no parameters are specified.
>
> All default values will be used instead.

The following keys can be defined:

**webroot\_public**

>   A boolean value (False by default) telling the webserver
>    configuration to use /public as entry point. This is required for
>    some frameworks such as Laravel or Zend Framework.

**webroot**

>   A string with the desired webroot location instead of auto-generated
>    one based on the domain.

**aliases**

>   A list of aliasses (with a dash in front of them) that need to be
>    added to the vhost.

**redirect\_to**

>   A string which will - if set - redirect the domain to the given URL
>    and uses the `redirect` vhost template.

> This may be used in conjunction with `ssl`

**proxy\_pass**

>   A string which will - if set - setup the webserver to proxy the domain to
>    the given URL and uses the `proxy` vhost template.

> This may be used in conjunction with `ssl`

**ssl**

>   A dictionary containing at least `key` and `cert`, optionally `ca`
>    for the CA chain (required for certain SSL providers), boolean
>    `forward` to force non-ssl to SSL and boolean `spdy` to enable SPDY
>    mode (if a compatible webserver is being used).

>   Setting "letsencrypt" to "True" results in automatically retrieve and renew
>   a certificate for this domain via LetsEncrypt

**listen\_ip**

>   A string containing the listen IP (any IP by default, may be set to
>    a specific one. Please note: all vhosts should be explicitly set if
>    this is being used!)

**listen\_port**

>   The webserver listens on port 80, can be overruled using this.

**listen\_port\_ssl**

>   Same as `listen_port` but for SSL.

> Depending on the vhost template more parameters may provided (e.g for nginx: ``logdir``, ``try_files``, ``index``, ``fastcgi_pass``, ``fastcgi_params`` or ``extra_config``)

### MySQL Databases

If the ``mysql_database`` key is specified in the user-tree of the vhosting pillar it will automatically install MariaDB 10.0 via the built-in state.
A user can have one or more databases and will always get a 'pair' consisting of: a database, a user and the specified password.

The minimal configuration for a MySQL database is:

```yaml
vhosting:
  users:
    example:
      mysql_database:
        example:
          password: 'topsecret'
```

The following keys can be defined:

**host**
> A string containing the host the grant should be made on.
> By default this is localhost, but you can set this to any host (including  ``%``)

**hosts**
> A list (with a dash) containing all hosts and IP's additional grants
> should be created for. All privileges are granted with the same password as
> the global user.

### Cronjobs
Since the ``cron`` daemon is always installed and running it is not being installed or managed directly by this formula.
If one or more cronjobs are specified for a user they will be installed. Cronjobs are created under the user they belong to in the tree.

The minimal configuration for a cronjob is:

```yaml
vhosting:
  users:
    example:
      cronjob:
        example:
          cmd: '/tmp/test.sh'
```          

If no times are set, the ``*`` value is being used (run every minute on every day etc).

Optionally the following keys can be specified:

**user**
> A string the cronjob should run as, by default the owner where the cron is placed under

**minute**
> The minute(s) the cron should run on

**hour**
> The hour(s) the cron should run on

**daymonth**
> The day of the month the cron should run on

**month**
> The month the cron should run on

**dayweek**
> The day of the week the cron should run on

**comment**
> An optional comment

### PHP-FPM Versions

The vhosting module recognizes either the vanilla PHP-FPM 5.5 installation, or any combination of PHP-FPM 5.6 and PHP-FPM 7, provided by Ondřej Surý via the PPA.
When specified, either PHP 5.6, PHP-FPM 7.0, or a combination of both will be installed.

Because both the phpfpm formula and the vhosting formula need to know what PHP-FPM versions are to be used, this must be set on both the global level like so:

```yaml
phpfpm:
  php_versions:
    - '5.6'
    - '7.0'
```

and on a per vhost basis as well:

```yaml
vhosting:
  users:
    example:
      vhost:
        example.com:
          php_version: '7.0'
```

This also allows for choosing between PHP 5.6 and PHP 7.0 on a per vhost basis.

If both the global PHP-FPM versions and the per vhost configuration are omitted, PHP 5.5 will be used instead.

#### Some warnings
* It is not possible to use PHP-FPM 5.5 together with either 5.6 or 7.0, as 5.6 will remove 5.5 and the formula does not manage 7.0 alongside 5.5.
* If other packages depend on either the package or service php5-fpm, it is not possible to use PHP-FPM 5.6 or 7.0, because of the init script being renamed.
* Support for native PHP7 (e.g. as provided in Ubuntu 16.04) is not yet implemented and requires the alternative versions setup to be used
