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
        , _fivetran_deleted date_modification
        , convert_timezone('UTC', _fivetran_synced) AS date_load_UTC
    FROM src_promos
    union all 
    SELECT
    {{ dbt_utils.generate_surrogate_key(["'no_promo'"]) }}
    , 'no_promo'
    , null
    , null
    , null
    , null
    )
    

SELECT * FROM renamed_casted