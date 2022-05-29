{{ config(
    materialized = 'table',
    unique_key = 'day_date',
    incremental_strategy = 'delete+insert',
    tags = ['dfk'],
    cluster_by = ['day_date']
) }}

WITH mints AS (

    SELECT
        block_timestamp,
        harmony.dev.js_hextoint(DATA) :: INTEGER / pow(
            10,
            18
        ) AS valuee
    FROM
        harmony.dev.logs
    WHERE
        {{ incremental_last_x_days(
            'block_timestamp',
            3
        ) }}
        AND evm_contract_address = '0x72cb10c6bfa5624dd07ef608027e366bd690048f'
        AND topics [0] = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        AND topics [1] = '0x0000000000000000000000005ca5bcd91929c7152ca577e8c001c9b5a185f568'
),
daily_mints AS (
    SELECT
        DATE_TRUNC(
            'day',
            block_timestamp
        ) AS day_date,
        SUM(valuee) AS mints
    FROM
        mints
    GROUP BY
        1
),
burns AS (
    SELECT
        block_timestamp,
        harmony.dev.js_hextoint(DATA) :: INTEGER / pow(
            10,
            18
        ) AS valuee
    FROM
        harmony.dev.logs
    WHERE
        1 = 1
        AND evm_contract_address = '0x72cb10c6bfa5624dd07ef608027e366bd690048f'
        AND topics [0] = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        AND topics [2] = '0x0000000000000000000000005ca5bcd91929c7152ca577e8c001c9b5a185f568'
),
daily_burns AS (
    SELECT
        DATE_TRUNC(
            'day',
            block_timestamp
        ) AS day_date,
        SUM(valuee) AS burns
    FROM
        burns
    GROUP BY
        1
)
SELECT
    NVL(
        m.day_date,
        b.day_date
    ) AS day_date,
    m.mints,
    b.burns
FROM
    daily_mints m full
    OUTER JOIN daily_burns b
    ON m.day_date = b.day_date
ORDER BY
    1
