{{ 
    config(
        materialized='incremental',
        unique_key='day_date',
        incremental_strategy = 'delete+insert',
        tags=['core', 'ant_ingest'],
        cluster_by=['day_date']
        )
}}

--  TODO: Redesign this table

with
old_source_table as (

    select
        ingest_timestamp::timestamp as ingest_timestamp,
        try_parse_json(ingest_data) as parsed_data
    from {{ source("ingest","src_old_ant_ingest") }}
    where 
        {% if is_incremental() %}
            ingest_timestamp > ( select max(day_date) from {{ this }} )
        {% else %}
            true
        {% endif %}  
        and ingest_timestamp < '2022-03-07 15:00:00.000'

),
current_source_table as (

    select
        ingest_timestamp::timestamp as ingest_timestamp,
        try_parse_json(ingest_data) as parsed_data
    from {{ source("ingest","ant_ingest") }}
    where 
        {% if is_incremental() %}
            ingest_timestamp > ( select max(day_date) from {{ this }} )
        {% else %}
            true
        {% endif %}  
        and ingest_timestamp > '2022-03-07 15:00:00.000'

),
source_table as (

    select * from old_source_table
    union all 
    select * from current_source_table

),

parsed_injest as (
    select
        *
    from source_table
    where parsed_data:type = 'tranquil_ingest'
),

final as (
    select
        date_trunc('day',ingest_timestamp) as day_date,
        avg(parsed_data:data::float) as tranq_tvl
    from parsed_injest
    group by 1
)

select * from final
