{{
  config(
    materialized='incremental',
    unique_key='"AccountNumberFull"',
    on_schema_change='fail'
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

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

