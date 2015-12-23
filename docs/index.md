# Enrise Vhosting Formula

A saltstack formula to manage … a lot actually :-).

This Saltstack formula takes care of provisioning your webstack, creates vhosts and databases and serves as an extendable base.

This wraps around several other other [Enrise formulas](https://github.com/enrise/?query=formula), which are required depending on your use-case:
* [Nginx-formula](https://github.com/enrise/nginx-formula) or the  [Apache-formula](https://github.com/enrise/apache-formula)
* [Zendserver-formula](https://github.com/enrise/zendserver-formula)
* [Mariadb-formula](https://github.com/enrise/mariadb-formula)

These formulas should also be installed on your Salt environment.

The `pillar.example` provides an complete overview of the possibilities
but there is more…

> **Note:**
>
> This formula has only been tested on **Ubuntu 14.04**.
>
> It will most likely not work on other platforms due to hardcoded
> package names and Ubuntu-specific commands.
