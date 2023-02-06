with
    users as (select * from {{ ref("users") }}),
    unique_domains as (
        select
            id,
            case
                when id = 1
                then null
                when id = 2
                then replace(email, '@example.com', '')
                when id = 3
                then email || '.au'
                when id = 4
                then upper(email)
                else email
            end as email
        from users
    )

select
    id,
    email,
    {{ dbt_privacy.mask_email("email") }} as default_mask,
    {{ dbt_privacy.mask_email("email", mask_char="/", n=2) }} as slash_2_mask,
    {{ dbt_privacy.mask_email("email", domain_n=20) }} as domain_n_20,
    {{ dbt_privacy.mask_email("email", domain_n=20, lowercase=False) }}
    as domain_n_20_case_sensitive

from unique_domains
