{{
  config(
    materialized='table'
  )
}}

SELECT 
    ROW_NUMBER() OVER (ORDER BY "OrderNumber") AS "FactMembershipTransactionId",
    (SELECT "DimClubId" FROM {{ ref('DimClubs') }} dc WHERE dc."ClubNumber" = st."ClubNumber" LIMIT 1) AS "DimClubNumberId",
    (SELECT "DimMembershipAccountId" FROM {{ ref('DimMembershipAccounts') }} dma WHERE dma."AccountNumber" = st."AccountNumber" LIMIT 1) AS "DimMembershipAccountId",
    (SELECT "DimDateId" FROM {{ ref('DimDates') }} dd WHERE dd."Date" = st."TransactionDate" LIMIT 1) AS "DimDateTransactionDateId",
    (SELECT "DimDateId" FROM {{ ref('DimDates') }} dd WHERE dd."Date" = st."EffectiveDate" LIMIT 1) AS "DimDateEffectiveDateId",
    (SELECT "DimDateId" FROM {{ ref('DimDates') }} dd WHERE dd."Date" = st."ExpiredDate" LIMIT 1) AS "DimDateExpiredDateId",
    "AccountNumber",
    "OrderNumber",
    "TransactionDate",
    "AccountType",
    "TransactionType",
    "ExpiredDate",
    "EffectiveDate",
    "HomeCostCenter",
    "PlatinumTransaction",
    "SalesOrderNumber",
    "InvoiceNumber",
    "TotalCost",
    "TotalUsdCostNet",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
    
FROM {{ ref('StgFactMembershipTransactions') }} st
