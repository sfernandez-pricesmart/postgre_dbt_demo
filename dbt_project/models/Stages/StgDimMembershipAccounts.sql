{{
  config(
    materialized='incremental',
    unique_key='"AccountNumberFull"',
    on_schema_change='fail'
  )
}}

WITH base AS (
    SELECT 
        CONCAT(TRIM(MA."Cost_Center"), 
               RIGHT(CONCAT('000000', TRIM(MA."Account_Number")), 6))::INTEGER AS "AccountNumberFull",
        MA."Cost_Center"::VARCHAR(4) AS "ClubNumber",
        {{ convert_empty_string_to_null('MA."Home_Business_Unit"', 'VARCHAR(4)') }} AS "HomeClubNumber",
        MA."Account_Type"::VARCHAR(2) AS "AccountType",
        TRIM(MA."Account_Number")::NUMERIC(6) AS "AccountNumber",
        {{ convert_empty_string_to_null('MA."Complimentary"', 'VARCHAR(1)') }} AS "Complimentary",
        MA."Date_Account_Opened"::DATE AS "DateAccountOpened",
        MA."Effective_Date"::DATE AS "EffectiveDate",
        MA."Expiration_Date"::DATE AS "ExpirationDate",
        MA."Cancel_Date"::DATE AS "CancelDate",
        {{ convert_empty_string_to_null('MA."Business_Name"', 'VARCHAR(60)') }} AS "BusinessName",
        {{ convert_empty_string_to_null('MA."BS_Business_Type"', 'VARCHAR(3)') }} AS "BSBusinessType",
        CASE WHEN MA."Platinum_Account" = 'Y' THEN TRUE ELSE FALSE END AS "PlatinumAccount",
        MA."Number_of_Employees"::NUMERIC(15) AS "NumberOfEmployees",
        {{ convert_empty_string_to_null('MA."Business_License_Number"', 'TEXT') }} AS "BusinessLicenseNumber",
        MA."updated_at" AS "updated_at",
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(MA."Cost_Center"), TRIM(MA."Account_Number")
            ORDER BY MA."Effective_Date" DESC NULLS LAST
        ) AS rn
    FROM {{ source('LakehouseAs400', 'PROD_membership_accounts') }} AS MA
    WHERE LENGTH(TRIM(MA."Cost_Center")) <= 4
    {% if is_incremental() %}
        AND MA."updated_at" > (
            SELECT "updated_at" 
            FROM {{ this }} 
            ORDER BY "updated_at" DESC 
            LIMIT 1
        )
    {% endif %}
)

SELECT *
FROM base
WHERE rn = 1
