{% test uniform(model, column_name) %}
with
    grouped as (select {{ column_name }} from {{ model }} group by 1),
    validation_errors as (select * from grouped limit 10000 offset 1)
select *
from validation_errors
{% endtest %}
