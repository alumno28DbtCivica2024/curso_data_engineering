{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT 
        order_id
        , shipping_service
        , shipping_cost
        , address_id
        , convert_timezone('UTC', created_at) as created_at_UTC
        , coalesce(nullif(promo_id,''), 'no_promo') as promo_id
        , convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at_UTC
        , order_cost
        , user_id
        , order_total
        , convert_timezone('UTC', delivered_at) as delivered_at_UTC
        , tracking_id
        , status
        , _fivetran_deleted 
        , convert_timezone('UTC', _fivetran_synced) as date_load_UTC 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id
        , coalesce(nullif(shipping_service,''), 'pendiente_asignación') as shipping_service
        , shipping_cost
        , address_id
        , created_at_UTC
        , {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id
        , estimated_delivery_at_UTC
        , order_cost
        , user_id
        , order_total
        , delivered_at_UTC
        , nullif(tracking_id,'') as tracking_id
        , status
        , _fivetran_deleted as date_modification
        , date_load_UTC
    FROM src_orders
    )
    
    
SELECT * FROM renamed_casted