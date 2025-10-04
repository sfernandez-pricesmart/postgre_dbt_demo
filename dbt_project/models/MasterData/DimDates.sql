{{
  config(
    materialized='incremental',
    unique_key='"Date"',
    on_schema_change='fail'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "Date") AS "DimDateId",
    "Date",
    "Year",
    "Month",
    "Day",
    "Quarter",
    "Week",
    "DayOfWeek",
    "IsWeekend",
    "IsHoliday",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM {{ ref('StgDimDates') }}

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

