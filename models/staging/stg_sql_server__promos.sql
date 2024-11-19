{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id
        , promo_id as promo_name
        , discount
        , status
        , _fivetran_deleted AS date_modication
        , _fivetran_synced AS date_load
    FROM src_promos
    union ALL
    SELECT 
        {{ dbt_utils.generate_surrogate_key(["'NO_PROMO'"]) }},
        'NO_PROMO',
        NULL,
        NULL,
        NULL,
        NULL
    )
    

SELECT * FROM renamed_casted