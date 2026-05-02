{{
    config(
        materialized='incremental',
        schema='silver',
        unique_key='order_id'
    )
}}

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.update_at,
    c.dbt_valid_from,
    c.dbt_valid_to,
    o.order_id,
    sum(o.quantity) as total_quantity,
    sum(o.total_amount) as total_revenue

from {{ ref('dim_customer') }} c

join {{ ref('bronze_orders') }} o
    on c.customer_id = o.customer_id

{% if is_incremental() %}

where o.update_at >
(
    select coalesce(max(update_at), '1900-01-01')
    from {{ this }}
)

{% endif %}

group by
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.update_at,
    c.dbt_valid_from,
    c.dbt_valid_to,
    o.order_id