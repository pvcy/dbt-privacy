with
    users as (select * from {{ ref("users") }}),
    peppers as (
        select
            id,
            {{ dbt_privacy.generate_pepper(pepper_scope="project") }} as project_pepper,
            {{ dbt_privacy.generate_pepper(pepper_scope="target") }} as target_pepper,
            {{ dbt_privacy.generate_pepper(pepper_scope="model") }} as model_pepper,
            {{
                dbt_privacy.generate_pepper(
                    pepper_scope="project", pepper_persistence="ephemeral"
                )
            }} as ephemeral_project_pepper
        from users
    )
select *
from peppers
