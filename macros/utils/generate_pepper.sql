{%- macro generate_pepper(pepper_scope="model", pepper_persistence="permanent") -%}
{{- dbt_privacy.raise_on_bad_scope(pepper_scope) -}}
{{- dbt_privacy.raise_on_bad_persistence(pepper_persistence) -}}

{%- set pepper = env_var('DBT_PRIVACY_PEPPER_SEED', '549286495') ~ context['project_name'] -%}

{%- if pepper_scope == "target" -%}
{%- set pepper = pepper ~ target.profile_name ~ target.name -%}
{%- elif pepper_scope == "model" -%}{%- set pepper = pepper ~ this -%}
{%- endif -%}

{%- if pepper_persistence == "ephemeral" -%}
{%- set pepper = pepper ~ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f %z") -%}
{%- endif -%}

{{- dbt_privacy.simple_hash(dbt_privacy.sql_quote_string(pepper), digest_size=256) -}}

{%- endmacro -%}

{%- macro raise_on_bad_scope(pepper_scope, ok_scopes=["model", "target", "project"]) -%}
{%- if pepper_scope not in ok_scopes %}
{%- set ok_list = ok_scopes | join(", ") -%}
{{-
    exceptions.raise_compiler_error(
                "Pepper scope must be one of " ~ ok_list ~ ". Got: " ~ pepper_scope
            )
-}}
{%- endif -%}
{%- endmacro -%}

{%- macro raise_on_bad_persistence(
    pepper_persistence, ok_persistence=["permanent", "ephemeral"]
) -%}
{%- if pepper_persistence not in ok_persistence -%}
{%- set ok_list = ok_persistence | join(", ") -%}
{{-
    exceptions.raise_compiler_error(
                "Pepper persistence must be one of " ~ ok_list ~ ". Got: " ~ pepper_persistence
            )
-}}
{%- endif -%}
{%- endmacro -%}
