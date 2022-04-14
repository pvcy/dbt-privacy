{%- macro redact_unique(expr, lowercase=true, redact_expr="'**REDACTED**'", n=1) -%}
{%- set raw_expr = expr -%}
{%- if lowercase == true -%}{%- set expr = dbt_privacy.sql_lower(expr) -%}{%- endif -%}
case
    when count(*) over (partition by {{ expr }}) <= {{ n }}
    then {{ redact_expr }}
    else {{ raw_expr }}
end
{%- endmacro -%}
