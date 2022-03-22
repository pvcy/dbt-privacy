with
    users as (select * from {{ ref("users") }}),
    duped as (
        select id, email, 0 as n
        from users
        where id != 1
        union all
        select id, upper(email) as email, 1 as n
        from users
    )
select
    id,
    n,
    {{ dbt_privacy.hash_unique("email") }} as email,
    {{ dbt_privacy.hash_unique("email", lowercase=false) }} as email_case_sensitive,
    {{ dbt_privacy.redact_unique("email") }} as redact_email,
    {{ dbt_privacy.redact_unique("email", lowercase=false) }}
    as redact_email_case_sensitive
from duped
