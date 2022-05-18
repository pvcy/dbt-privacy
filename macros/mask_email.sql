{%- macro mask_email(expr, mask_char="*", n=8, domain_n=100, lowercase=True) -%}

{%- set domain = dbt_privacy.split_part(expr, "'@'", 2) -%}
{%- if lowercase == true -%}
{%- set domain_partition = dbt_privacy.sql_lower(domain) -%}
{%- else -%} {%- set domain_partition = domain -%}
{%- endif -%}

{{ dbt_privacy.safe_mask(expr, mask_char=mask_char, n=n) }} || '@' || (
    case
        when 
            {{ domain }} is not null
            and count(*) over (
                partition by {{ domain_partition }}
            ) > {{ domain_n }}
        then {{ domain }}
        else {{ dbt_privacy.safe_mask(expr, mask_char=mask_char, n=n) }}
    end
)
{%- endmacro -%}
