# Ensure the webistrano-key is added to this user
{% macro create(salt, baseconf, username, enabled) -%}
{% if enabled %}
webistrano_key_{{ username }}:
  ssh_auth.present:
    - user: {{ username }}
    - source: 'salt://ssh/keys/webistrano.pub'
    - require:
      - user: {{ username }}
{% endif %}
{%- endmacro %}
