{{
  config(
    materialized='table'
  )
}}

SELECT 
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
    "AutoCharge"
    
FROM {{ ref('StgDimMembershipCards') }}
