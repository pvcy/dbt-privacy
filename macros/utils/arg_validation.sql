{%- macro raise_on_negative(n,  label) -%}
{%- if n < 0 -%}
{{ exceptions.raise_compiler_error(label ~ " cannot be negative") }}
{%- endif -%}
{%- endmacro -%}

{%- macro raise_on_bad_mask_char(mask_char) -%}
{%- if mask_char | length != 1 -%}
{{ 
    exceptions.raise_compiler_error(
        "mask_char must be single character. Got: " ~ mask_char
    )
}}
{%- endif -%}
{%- endmacro -%}

{%- macro raise_on_bad_keep_dir(keep_dir, ok_dirs=["left", "right"]) -%}
{%- if keep_dir not in ok_dirs -%}
{%- set ok_list = ok_dirs | join(", ") -%}
{{
    exceptions.raise_compiler_error(
        "keep_dir must be one of " ~ ok_list ~ ". Got: " ~ keep_dir
    )
}}
{%- endif -%}
{%- endmacro -%}
