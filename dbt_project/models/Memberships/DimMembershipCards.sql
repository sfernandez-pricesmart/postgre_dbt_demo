{{
  config(
    materialized='incremental',
    unique_key='"MembershipNumber"',
    on_schema_change='fail'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "MembershipNumber") AS "DimMembershipCardId",
    "MembershipNumber"::VARCHAR(30) AS "MembershipNumber",
    "AccountNumberFull"::VARCHAR(20) AS "AccountNumberFull",
    "ClubNumber",
    "CardNumber"::VARCHAR(10) AS "CardNumber",
    "BlockStatus"::VARCHAR(10) AS "BlockStatus",
    "CancelDate",
    "HasCellPhone"::VARCHAR(1) AS "HasCellPhone",
    "HasEmail"::VARCHAR(1) AS "HasEmail",
    "MemEvent"::VARCHAR(10) AS "MemEvent",
    "Zone"::VARCHAR(20) AS "Zone",
    "AwarenessCode"::VARCHAR(10) AS "AwarenessCode",
    "WayOfNotification"::VARCHAR(20) AS "WayOfNotification",
    "DateOfBirth"::DATE AS "DateOfBirth",
    "IssuedDate",
    "Gender",
    "CardType"::VARCHAR(10) AS "CardType",
    "Country"::VARCHAR(50) AS "Country",
    "DiamondBusinessType"::VARCHAR(10) AS "DiamondBusinessType",
    "MemberStatus"::VARCHAR(10) AS "MemberStatus",
    "PrimaryCard"::VARCHAR(1) AS "PrimaryCard",
    "Dual"::VARCHAR(1) AS "Dual",
    "AutoCharge"::VARCHAR(1) AS "AutoCharge",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM {{ ref('StgDimMembershipCards') }}

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

