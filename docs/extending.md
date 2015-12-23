# Extending

The formula is very flexible. It allows you simply extend the system by
configuring more in Pillar and creating macro-files. For instance, if
you want to add a custom resource you can simply create
vhosting/resources/ssh\_key\_deploy.sls in your own states directory (as
configured in your Salt fileserver). Due to the nature of Salt’s
fileserver, any directories higher than the formulas directory will be
included first. This allows you to add in new components or replace
core-components.

Resources makes use of macro’s placed in the `resources` folder which
all need to provide the `create` macro. For instance if you want redis
databases to be created, create `redis_database.sls` in the resources
folder and execute all configured commands in this macro.

In some cases you may need to retrieve additional information from
pillars (e.g ‘higher’ values).

```jinja
{% macro create(salt, baseconf, owner, params={}, name=None) %}
# Do stuff here.
{% endmacro %}
```

Description of the macro parameters:

**salt**
> The `salt` object can be used to query Salt directly (grains, pillars) which is not possible in macro’s otherwise.

**baseconf**
> This exposes the `webstack` generated in the `map.jinja` containing paths/defaults depending on the enviroment.

**owner**
> The key this object is located under, which is generally considered the owner of the resource.


**params**
> A single-value (string, bool) or a dictionary consisting of the given params.
> If it is a dictionary it can be queried like
> `params.get('keyname','default_value)`


**name**
> An optional parameter which may contain a the individual key name (in case of > nested-dictionaries such as implemented with the vhosts or mysql\_databases
> which are available by default.
