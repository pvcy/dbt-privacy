{%- macro hash(
    expr,
    lowercase=true,
    salt_expr="''",
    pepper_scope="model",
    pepper_persistence="permanent",
    digest_size=256
) -%}

{%- if lowercase == true -%}{% set expr = dbt_privacy.sql_lower(expr) %}{%- endif -%}

{%- if salt_expr not in ("", "''") -%}
{% set salt = dbt_privacy.simple_hash(salt_expr, digest_size) %}
{%- else -%}
{% set salt = "''" %}
{%- endif -%}

{%- set pepper = dbt_privacy.generate_pepper(
    pepper_scope=pepper_scope, pepper_persistence=pepper_persistence
) -%}

{{- dbt_privacy.simple_hash(salt ~ ' || ' ~ expr ~ ' || ' ~ pepper, digest_size) -}}

{%- endmacro -%}
