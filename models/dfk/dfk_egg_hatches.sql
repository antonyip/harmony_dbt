  {{ 
    config(
        materialized='incremental',
        unique_key='log_id',
        incremental_strategy = 'delete+insert',
        tags=['dfk'],
        cluster_by=['block_timestamp']
        ) 
}}

select 
    *
from harmony.dev.logs 
where block_timestamp > '2022-05-15'
    and {{ incremental_last_x_days('block_timestamp', 3) }}
    and topics[0] = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
    and evm_contract_address = '0xac9afb5900c8a27b766bcad3a37423dc0f4c22d3'