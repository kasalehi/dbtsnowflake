
{% snapshot dim_customer %}

{{
    config(
        target_schema='silver',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='UPDATE_AT'
    )
}}

with ranked as (

    select *,

        row_number() over (
            partition by customer_id
            order by update_at desc
        ) as rn

    from {{ ref('bronze_customer') }}

)

select *
from ranked
where rn = 1

{% endsnapshot %}




