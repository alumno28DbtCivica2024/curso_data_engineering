{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id
        , convert_timezone('UTC', updated_at) as updated_at_UTC
        , address_id
        , last_name
        , created_at
        , phone_number
        , first_name
        , email
        , _fivetran_deleted as date_modification
        , convert_timezone('UTC', _fivetran_synced) AS date_load_UTC
    FROM src_users
    )
    

SELECT * FROM renamed_casted