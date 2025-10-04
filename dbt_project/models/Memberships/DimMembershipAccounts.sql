{{
  config(
    materialized='table'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "AccountNumberFull") AS "DimMembershipAccountId",
    "AccountNumberFull",
    "ClubNumber",
    "HomeClubNumber",
    "AccountType",
    "AccountNumber",
    "Complimentary",
    "DateAccountOpened",
    "EffectiveDate",
    "ExpirationDate",
    "CancelDate",
    "BusinessName",
    "BSBusinessType",
    "PlatinumAccount",
    "NumberOfEmployees",
    "BusinessLicenseNumber",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
    
FROM {{ ref('StgDimMembershipAccounts') }}
