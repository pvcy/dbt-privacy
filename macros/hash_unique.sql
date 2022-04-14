{%- macro hash_unique(
    expr,
    lowercase=true,
    salt_expr="''",
    pepper_scope="model",
    pepper_persistence="permanent",
    digest_size=256,
    n=1
) -%}
{%- set raw_expr = expr -%}
{%- if lowercase == true %}{%- set expr = dbt_privacy.sql_lower(expr) -%}{%- endif -%}
case
    when count(*) over (partition by {{ expr }}) <= {{ n }}
    then
        {{
            dbt_privacy.hash(
                expr,
                lowercase=false,
                salt_expr=salt_expr,
                pepper_scope=pepper_scope,
                pepper_persistence=pepper_persistence,
                digest_size=digest_size,
            )
        }}
    else {{ raw_expr }}
end
{%- endmacro -%}
