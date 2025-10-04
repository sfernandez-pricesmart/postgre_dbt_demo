{{
  config(
    materialized='incremental',
    unique_key='"ClubNumber"',
    on_schema_change='fail'
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

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}
