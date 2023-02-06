with
    users as (select * from {{ ref("users") }}),
    pseudonymized as (
        select
            id,
            email,
            {{ dbt_privacy.mask("email") }} as default_mask,
            {{ dbt_privacy.mask("email", mask_char="/") }} as slash_mask,
            {{ dbt_privacy.mask("email", keep_n=4) }} as keep_4_mask,
            {{ dbt_privacy.mask("email", keep_n=6, keep_dir="left") }}
            as keep_6_left_mask,
            {{ dbt_privacy.mask("null") }} as null_mask
        from users
    )
select *
from pseudonymized
