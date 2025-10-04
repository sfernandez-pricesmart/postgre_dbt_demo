{{
  config(
    materialized='table'
  )
}}

SELECT 
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
    "BusinessLicenseNumber"
    
FROM {{ ref('StgDimMembershipAccounts') }}
