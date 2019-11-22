# Enrise Vhosting Formula

[![Documentation](https://readthedocs.org/projects/vhosting-formula/badge/?version=latest)](http://vhosting-formula.readthedocs.org/)
[![Travis branch](https://img.shields.io/travis/Enrise/vhosting-formula/master.svg?style=flat-square)](https://travis-ci.org/Enrise/vhosting-formula)

This Saltstack formula takes care of provisioning your webstack, creates vhosts and databases and serves as an extendable base.

This wraps around several other other [Enrise formulas](https://github.com/enrise/?query=formula).

The `pillar.example` provides an complete overview of the possibilities
but there is more…

> **note**
>
> This formula has **only been tested on Ubuntu 14.04/16.04/18.04**.
>
>     It will most likely not work on other platforms due to hardcoded
>     package names and Ubuntu-specific commands.
>
