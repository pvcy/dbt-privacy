{% macro safe_mask(expr, mask_char="*", n=8, keep_n=0, keep_dir='right') %}
{{- dbt_privacy.raise_on_bad_mask_char(mask_char) -}}
{{- dbt_privacy.raise_on_negative(n, "n") -}}
{{- dbt_privacy.raise_on_negative(keep_n, "keep_n") -}}
{{- dbt_privacy.raise_on_bad_keep_dir(keep_dir) -}}
{{- return(adapter.dispatch("safe_mask", "dbt_privacy")(expr, mask_char, n, keep_n, keep_dir)) -}}  
{% endmacro %}

{%- macro default__safe_mask(expr, mask_char, n, keep_n, keep_dir) -%}
case
    when {{ expr }} is null 
    then null
    else
        {% if keep_dir == "left" and keep_n > 0 -%}
        left({{ expr }}, {{ keep_n }}) || {{- " " -}}
        {%- endif -%}
        '{{- mask_char * n -}}'
        {%- if keep_dir == "right" and keep_n > 0 -%}
        {{- " " -}} || right({{ expr }}, {{ keep_n }})
        {%- endif %}
end
{%- endmacro -%}
