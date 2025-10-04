{{
  config(
    materialized='incremental',
    unique_key='"OrderNumber"',
    on_schema_change='fail'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "OrderNumber") AS "FactMembershipTransactionId",
    (SELECT "DimClubId" FROM "MasterData"."DimClubs" dc WHERE dc."ClubNumber" = st."ClubNumber" LIMIT 1) AS "DimClubNumberId",
    (SELECT "DimMembershipAccountId" FROM "Memberships"."DimMembershipAccounts" dma WHERE dma."AccountNumber" = st."AccountNumber" LIMIT 1) AS "DimMembershipAccountId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = st."TransactionDate" LIMIT 1) AS "DimDateTransactionDateId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = st."EffectiveDate" LIMIT 1) AS "DimDateEffectiveDateId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = st."ExpiredDate" LIMIT 1) AS "DimDateExpiredDateId",
    "AccountNumber",
    "OrderNumber"::VARCHAR(20) AS "OrderNumber",
    "TransactionDate",
    "AccountType",
    "TransactionType"::VARCHAR(20) AS "TransactionType",
    "ExpiredDate",
    "EffectiveDate",
    "HomeCostCenter",
    "PlatinumTransaction"::VARCHAR(1) AS "PlatinumTransaction",
    "SalesOrderNumber"::VARCHAR(20) AS "SalesOrderNumber",
    "InvoiceNumber"::VARCHAR(20) AS "InvoiceNumber",
    "TotalCost",
    "TotalUsdCostNet",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM {{ ref('StgFactMembershipTransactions') }} st

{% if is_incremental() %}
    -- Merge strategy: process all records from staging (new + updated)
    -- dbt will handle the merge based on unique_key
{% endif %}

