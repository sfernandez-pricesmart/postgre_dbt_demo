{{
  config(
    materialized='incremental',
    unique_key='"AccountNumberFull"',
    on_schema_change='fail'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "AccountNumberFull") AS "DimMembershipAccountId",
    "AccountNumberFull"::VARCHAR(20) AS "AccountNumberFull",
    "ClubNumber",
    "HomeClubNumber"::VARCHAR(4) AS "HomeClubNumber",
    "AccountType",
    "AccountNumber",
    "Complimentary"::VARCHAR(1) AS "Complimentary",
    "DateAccountOpened",
    "EffectiveDate",
    "ExpirationDate",
    "CancelDate",
    "BusinessName"::VARCHAR(100) AS "BusinessName",
    "BSBusinessType"::VARCHAR(10) AS "BSBusinessType",
    "PlatinumAccount"::VARCHAR(1) AS "PlatinumAccount",
    "NumberOfEmployees"::INTEGER AS "NumberOfEmployees",
    "BusinessLicenseNumber",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM {{ ref('StgDimMembershipAccounts') }}

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

