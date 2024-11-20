{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        product_id
        , price
        , name
        , inventory
        , _fivetran_deleted as date_modification
        , convert_timezone('UTC', _fivetran_synced) AS date_load_UTC
    FROM src_products
    )
    

SELECT * FROM renamed_casted