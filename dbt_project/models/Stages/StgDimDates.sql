{{
  config(
    materialized='ephemeral'
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
    d."Is_Holiday"::BOOLEAN AS "IsHoliday"
    
FROM {{ source('LakehouseAs400', 'PROD_dates') }} d
