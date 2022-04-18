with
    dim_users as (select * from {{ ref("dim_users") }}),
    pepper as (select * from {{ ref("pepper") }}),
    joined as (
        select
            dim_users.id,
            dim_users.project_pepper,
            dim_users.target_pepper,
            dim_users.model_pepper,
            dim_users.ephemeral_project_pepper,
            pepper.project_pepper as pepper__project_pepper,
            pepper.target_pepper as pepper__target_pepper,
            pepper.model_pepper as pepper__model_pepper,
            pepper.ephemeral_project_pepper as pepper__ephemeral_project_pepper
        from dim_users
        join pepper on dim_users.id = pepper.id

    )
select *
from joined
