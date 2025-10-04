{{
  config(
    materialized='incremental',
    unique_key='"ClubNumber"',
    on_schema_change='fail'
  )
}}

SELECT 
    c."Club_Number"::VARCHAR(4) AS "ClubNumber",
    c."Club_Name"::VARCHAR(50) AS "ClubName",
    c."Country"::VARCHAR(3) AS "Country",
    c."Zone"::VARCHAR(3) AS "Zone",
    c."Status"::VARCHAR(1) AS "Status",
    c."updated_at" AS "updated_at"
    
FROM {{ source('LakehouseAs400', 'PROD_clubs') }} c
