{{
  config(
    materialized='table'
  )
}}

SELECT 
    "Date",
    "Year",
    "Month",
    "Day",
    "Quarter",
    "Week",
    "DayOfWeek",
    "IsWeekend",
    "IsHoliday"
    
FROM {{ ref('StgDimDates') }}
