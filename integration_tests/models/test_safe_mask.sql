with
    users as (select * from {{ ref("users") }}),
    pseudonymized as (
        select
            id,            
            {{ dbt_privacy.safe_mask("email") }} as email_safe_mask,
            {{ dbt_privacy.safe_mask("email", mask_char="/") }} as email_safe_mask_slash,
            {{ dbt_privacy.safe_mask("email", keep_n=4) }} as email_safe_mask_keep_4,
            {{ dbt_privacy.safe_mask("email", n=8, keep_n=6, keep_dir="left") }} as email_safe_mask_keep_left,
            {{ dbt_privacy.safe_mask("null") }} as null_safe_mask
        from users
    )
select *
from pseudonymized
