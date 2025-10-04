{{
  config(
    materialized='incremental',
    unique_key='"MembershipNumber"',
    on_schema_change='fail'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "MembershipNumber") AS "DimMembershipCardId",
    "MembershipNumber",
    "AccountNumberFull",
    "ClubNumber",
    "CardNumber",
    "BlockStatus",
    "CancelDate",
    "HasCellPhone",
    "HasEmail",
    "MemEvent",
    "Zone",
    "AwarenessCode",
    "WayOfNotification",
    "DateOfBirth",
    "IssuedDate",
    "Gender",
    "CardType",
    "Country",
    "DiamondBusinessType",
    "MemberStatus",
    "PrimaryCard",
    "Dual",
    "AutoCharge",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM {{ ref('StgDimMembershipCards') }}

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

