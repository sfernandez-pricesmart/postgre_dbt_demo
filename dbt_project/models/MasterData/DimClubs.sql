{{
  config(
    materialized='table'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "ClubNumber") AS "DimClubId",
    "ClubNumber",
    "ClubName",
    "Country",
    "Zone",
    "Status",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
    
FROM {{ ref('StgDimClubs') }}
