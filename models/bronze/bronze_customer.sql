{{ config(
    materialized='incremental',
)
}}

select *
from {{ source('raw', 'customers') }} src


{% if is_incremental() %}
  where src.update_at > (select max(t.update_at) from {{ this }} t)
{% endif %}