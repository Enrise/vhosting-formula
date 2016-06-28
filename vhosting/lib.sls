# Library with macro's to make the code more readable
{% macro sls_block(dict) %}
{%- for key, value in dict.items() %}
  - {{ key }}: {{ value|json() }}
{%- endfor %}
{% endmacro %}

{% macro sls_list(dict) %}
{% for key, value in dict.items() %}
    {{ key }}: {{ value|json() }}
{% endfor %}
{% endmacro %}

{% macro path_join(file, root) -%}
{{ root ~ '/' ~ file }}
{%- endmacro %}

{% macro call_macro(salt, baseconf={}, owner=None, macro=None, params={}, name=None) %}
{% from "vhosting/resources/" ~ macro ~ '.sls' import create %}
{% if name %}
{{ create(salt, baseconf, owner, params, name) }}
{% else %}
{{ create(salt, baseconf, owner, params ) }}
{% endif %}
{% endmacro %}

{% macro get_webstack(salt, key, default=None) %}
{% from "vhosting/map.jinja" import webstack with context %}
{% endmacro %}

# Serializes dicts into sequenced data
{%- macro serialize(data) -%}
    {%- if data is mapping -%}
        {%- set ret = [] -%}
        {%- for key, value in data.items() -%}
            {%- set value = serialize(value)|load_json() -%}
            {%- do ret.append({key: value}) -%}
        {%- endfor -%}
    {%- elif data is iterable and data is not string -%}
        {%- set ret = [] -%}
        {%- for value in data -%}
            {%- set value = serialize(value)|load_json() -%}
            {%- do ret.append(value) -%}
        {%- endfor -%}
    {%- else -%}
        {% set ret = data %}
    {%- endif -%}

    {{ ret|json() }}
{%- endmacro -%}
