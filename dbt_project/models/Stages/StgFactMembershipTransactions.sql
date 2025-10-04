{{
  config(
    materialized='incremental',
    unique_key='"OrderNumber"',
    on_schema_change='fail'
  )
}}

SELECT 
    -- Data type casting and transformations
    t."Cost_Center"::VARCHAR(4) AS "ClubNumber",
    t."Account_Number"::NUMERIC(6,0) AS "AccountNumber",
    t."Order_Number"::NUMERIC(8) AS "OrderNumber",
    t."Transaction_Date"::DATE AS "TransactionDate",
    t."Account_Type"::VARCHAR(2) AS "AccountType",
    t."Transaction_Type"::VARCHAR(3) AS "TransactionType",
    t."Expired_Date"::DATE AS "ExpiredDate",
    t."Effective_Date"::DATE AS "EffectiveDate",
    t."Home_Cost_Center"::VARCHAR(4) AS "HomeCostCenter",
    {{ convert_empty_string_to_null('t."Platinum_Transaction"', 'VARCHAR(3)') }} AS "PlatinumTransaction",
    t."Sales_Order_Number"::NUMERIC(8) AS "SalesOrderNumber",
    t."Invoice_Number"::NUMERIC(8) AS "InvoiceNumber",
    t."Total_Cost"::NUMERIC(15,2) AS "TotalCost",
    t."Total_Usd_Cost_Net"::NUMERIC(15,2) AS "TotalUsdCostNet",
    t."updated_at" AS "updated_at"
    
FROM {{ source('LakehouseAs400', 'PROD_membership_transactions_header') }} t
WHERE 
    -- Filter out records with empty strings in TotalCost and TotalUsdCostNet fields
     t."Total_Usd_Cost_Net" IS NOT NULL and t."Total_Cost" IS NOT NULL AND
     t."Cost_Center" IS NOT NULL AND t."Cost_Center" != '' AND
     t."Account_Type" IN ('DI', 'BS') AND
     t."Effective_Date" IS NOT NULL AND
     t."Expired_Date" IS NOT NULL AND
     t."Transaction_Date" > '2023-09-01'
    {% if is_incremental() %}
        AND t."updated_at" > (
            SELECT "updated_at" 
            FROM {{ this }} 
            ORDER BY "updated_at" DESC 
            LIMIT 1
        )
    {% endif %}
