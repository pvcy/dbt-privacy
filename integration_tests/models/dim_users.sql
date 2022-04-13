with
    users as (select * from {{ ref("users") }}),
    pseudonymized as (
        select
            id,
            {{ dbt_privacy.hash("name", salt_expr="id") }} as name_hash,
            {{ dbt_privacy.hash("email", salt_expr="id") }} as email_hash,
            {{ dbt_privacy.hash("email", salt_expr="id", digest_size=512) }}
            as email_hash_512,
            {{ dbt_privacy.hash_unique("email", salt_expr="id") }} as unique_email_hash,
            {{ dbt_privacy.hash("email", salt_expr="name") }} as email_hash_name_salt,
            {{ dbt_privacy.hash("email") }} as email_hash_default_salt,
            {{ dbt_privacy.hash("email", salt_expr="") }} as email_hash_no_salt,
            {{ dbt_privacy.generate_pepper(pepper_scope="project") }} as project_pepper,
            {{ dbt_privacy.generate_pepper(pepper_scope="target") }} as target_pepper,
            {{ dbt_privacy.generate_pepper(pepper_scope="model") }} as model_pepper,
            {{
                dbt_privacy.generate_pepper(
                    pepper_scope="project", pepper_persistence="per-run"
                )
            }} as ephemeral_project_pepper
        from users
    )
select *
from pseudonymized
