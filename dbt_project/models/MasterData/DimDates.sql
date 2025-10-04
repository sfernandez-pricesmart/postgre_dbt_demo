{{
  config(
    materialized='table'
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
