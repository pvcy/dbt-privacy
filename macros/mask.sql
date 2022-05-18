{% macro mask(expr, mask_char="*", keep_n=0, keep_dir='right') %}
{{- dbt_privacy.raise_on_bad_mask_char(mask_char) -}}
{{- dbt_privacy.raise_on_negative(keep_n, "keep_n") -}}
{{- dbt_privacy.raise_on_bad_keep_dir(keep_dir) -}}
{{- return(adapter.dispatch("mask", "dbt_privacy")(expr, mask_char, n, keep_n, keep_dir)) -}}  
{% endmacro %}

{%- macro default__mask(expr, mask_char, n, keep_n, keep_dir) -%}
case
    when {{ expr }} is null 
    then null
    else
        {% if keep_dir == "left" and keep_n > 0 -%}
        left({{ expr }}, {{ keep_n }}) || {{- " " -}}
        {%- endif -%}
        repeat('{{ mask_char }}', length({{ expr }}){% if keep_n > 0 %} - {{ keep_n }}{% endif %})
        {%- if keep_dir == "right" and keep_n > 0 -%}
        {{- " " -}} || right({{ expr }}, {{ keep_n }})
        {%- endif %}
end
{%- endmacro -%}
