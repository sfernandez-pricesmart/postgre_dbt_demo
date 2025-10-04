{{
  config(
    materialized='table'
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
