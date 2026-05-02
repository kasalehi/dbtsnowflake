{{ config(
    materialized='incremental',
    unique_key='order_id',
) }}

select *
 from {{ source('raw', 'orders') }} src

{% if is_incremental() %}
  where src.update_at > (select max(t.update_at) from {{ this }} t)
{% endif %}