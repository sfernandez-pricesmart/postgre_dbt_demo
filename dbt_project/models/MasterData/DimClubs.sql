{{
  config(
    materialized='table'
  )
}}

SELECT 
    "ClubNumber",
    "ClubName",
    "Country",
    "Zone",
    "Status"
    
FROM {{ ref('StgDimClubs') }}
