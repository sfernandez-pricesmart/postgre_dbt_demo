{{
  config(
    materialized='ephemeral'
  )
}}

SELECT 
    c."Club_Number"::VARCHAR(4) AS "ClubNumber",
    c."Club_Name"::VARCHAR(50) AS "ClubName",
    c."Country"::VARCHAR(3) AS "Country",
    c."Zone"::VARCHAR(3) AS "Zone",
    c."Status"::VARCHAR(1) AS "Status"
    
FROM {{ source('LakehouseAs400', 'PROD_clubs') }} c
