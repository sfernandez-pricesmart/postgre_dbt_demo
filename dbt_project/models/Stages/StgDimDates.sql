{{
  config(
    materialized='incremental',
    unique_key='"Date"',
    on_schema_change='fail'
  )
}}

SELECT 
    d."Date"::DATE AS "Date",
    d."Year"::INTEGER AS "Year",
    d."Month"::INTEGER AS "Month",
    d."Day"::INTEGER AS "Day",
    d."Quarter"::INTEGER AS "Quarter",
    d."Week"::INTEGER AS "Week",
    d."Day_of_Week"::INTEGER AS "DayOfWeek",
    d."Is_Weekend"::BOOLEAN AS "IsWeekend",
    d."Is_Holiday"::BOOLEAN AS "IsHoliday",
    d."updated_at" AS "updated_at"
    
FROM {{ source('LakehouseAs400', 'PROD_dates') }} d

{% if is_incremental() %}
    WHERE d."updated_at" > (
        SELECT "updated_at" 
        FROM {{ this }} 
        ORDER BY "updated_at" DESC 
        LIMIT 1
    )
{% endif %}
