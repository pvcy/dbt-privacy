{%- macro simple_hash(expr, digest_size=256) -%}
{{- dbt_privacy.raise_on_bad_digest_size(digest_size) -}}
{{- return(adapter.dispatch("simple_hash", "dbt_privacy")(expr, digest_size)) -}}
{%- endmacro -%}

{%- macro default__simple_hash(expr, digest_size=256) -%}
sha2( ({{ expr }})::varchar, {{ digest_size }})
{%- endmacro -%}

{%- macro postgres__simple_hash(expr, digest_size=256) -%}
encode(sha{{ digest_size }} ( ({{ expr }})::varchar::bytea), 'hex')
{%- endmacro -%}

{%- macro bigquery__simple_hash(expr, digest_size=256) -%}
{{- dbt_privacy.raise_on_bad_digest_size(digest_size, ok_sizes=[256, 512]) -}}
to_hex(sha{{ digest_size }} (cast({{ expr }} as string)))
{%- endmacro -%}

{%- macro raise_on_bad_digest_size(digest_size, ok_sizes=[224, 256, 384, 512]) -%}
{%- if digest_size not in ok_sizes -%}
{%- set ok_list = ok_sizes | join(", ") -%}
{{
    exceptions.raise_compiler_error(
            "Digest size must be one of " ~ ok_list ~ ". Got: " ~ digest_size
        )
}}
{%- endif -%}
{%- endmacro -%}
