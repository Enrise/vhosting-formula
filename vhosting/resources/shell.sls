# Deal with "shell config" for this user
{% macro create(salt, baseconf, username, shell='/bin/bash') -%}
extend:
  {{ username }}:
    user.present:
      - shell: {{ shell }}
{%- endmacro %}
