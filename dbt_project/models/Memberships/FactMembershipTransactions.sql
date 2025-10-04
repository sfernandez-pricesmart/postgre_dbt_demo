{{
  config(
    materialized='table'
  )
}}

SELECT 
    "ClubNumber",
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
    "TotalUsdCostNet"
    
FROM {{ ref('StgFactMembershipTransactions') }}
