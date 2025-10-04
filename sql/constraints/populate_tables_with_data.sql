-- Populate Tables with Data from dbt Models
-- This script populates the tables with data from the existing dbt models
-- Run this after creating the tables with constraints

-- Populate DimClubs
INSERT INTO "MasterData"."DimClubs" (
    "DimClubId", "ClubNumber", "ClubName", "Country", "Zone", "Status", "CreateDate", "UpdateDate"
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY "ClubNumber") AS "DimClubId",
    "ClubNumber",
    "ClubName", 
    "Country",
    "Zone",
    "Status",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM (
    SELECT 
        c."Club_Number"::VARCHAR(4) AS "ClubNumber",
        c."Club_Name"::VARCHAR(50) AS "ClubName",
        c."Country"::VARCHAR(3) AS "Country",
        c."Zone"::VARCHAR(3) AS "Zone",
        c."Status"::VARCHAR(1) AS "Status"
    FROM "LakehouseAs400"."PROD_clubs" c
) source_data;

-- Populate DimDates
INSERT INTO "MasterData"."DimDates" (
    "DimDateId", "Date", "Year", "Month", "Day", "Quarter", "Week", "DayOfWeek", 
    "IsWeekend", "IsHoliday", "CreateDate", "UpdateDate"
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY "Date") AS "DimDateId",
    "Date",
    "Year",
    "Month", 
    "Day",
    "Quarter",
    "Week",
    "DayOfWeek",
    "IsWeekend",
    "IsHoliday",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM (
    SELECT 
        d."Date"::DATE AS "Date",
        EXTRACT(YEAR FROM d."Date")::INTEGER AS "Year",
        EXTRACT(MONTH FROM d."Date")::INTEGER AS "Month",
        EXTRACT(DAY FROM d."Date")::INTEGER AS "Day",
        EXTRACT(QUARTER FROM d."Date")::INTEGER AS "Quarter",
        EXTRACT(WEEK FROM d."Date")::INTEGER AS "Week",
        EXTRACT(DOW FROM d."Date")::INTEGER AS "DayOfWeek",
        CASE WHEN EXTRACT(DOW FROM d."Date") IN (0, 6) THEN TRUE ELSE FALSE END AS "IsWeekend",
        FALSE AS "IsHoliday"
    FROM "LakehouseAs400"."PROD_dates" d
) source_data;

-- Populate DimMembershipAccounts
INSERT INTO "Memberships"."DimMembershipAccounts" (
    "DimMembershipAccountId", "AccountNumberFull", "ClubNumber", "HomeClubNumber", 
    "AccountType", "AccountNumber", "Complimentary", "DateAccountOpened", "EffectiveDate", 
    "ExpirationDate", "CancelDate", "BusinessName", "BSBusinessType", "PlatinumAccount", 
    "NumberOfEmployees", "BusinessLicenseNumber", "CreateDate", "UpdateDate"
)
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
FROM (
    SELECT 
        CONCAT(MA."Cost_Center", MA."Account_Number") AS "AccountNumberFull",
        MA."Cost_Center"::VARCHAR(4) AS "ClubNumber",
        MA."Home_Business_Unit"::VARCHAR(4) AS "HomeClubNumber",
        MA."Account_Type"::VARCHAR(2) AS "AccountType",
        MA."Account_Number"::NUMERIC(6,0) AS "AccountNumber",
        MA."Complimentary"::VARCHAR(1) AS "Complimentary",
        MA."Date_Account_Opened"::DATE AS "DateAccountOpened",
        MA."Effective_Date"::DATE AS "EffectiveDate",
        MA."Expiration_Date"::DATE AS "ExpirationDate",
        MA."Cancel_Date"::DATE AS "CancelDate",
        MA."Business_Name"::VARCHAR(100) AS "BusinessName",
        MA."BS_Business_Type"::VARCHAR(10) AS "BSBusinessType",
        MA."Platinum_Account"::VARCHAR(1) AS "PlatinumAccount",
        MA."Number_of_Employees"::INTEGER AS "NumberOfEmployees",
        MA."Business_License_Number"::TEXT AS "BusinessLicenseNumber"
    FROM "LakehouseAs400"."PROD_membership_accounts" MA
) source_data;

-- Populate DimMembershipCards
INSERT INTO "Memberships"."DimMembershipCards" (
    "DimMembershipCardId", "MembershipNumber", "AccountNumberFull", "ClubNumber", 
    "CardNumber", "BlockStatus", "CancelDate", "HasCellPhone", "HasEmail", 
    "MemEvent", "Zone", "AwarenessCode", "WayOfNotification", "DateOfBirth", 
    "IssuedDate", "Gender", "CardType", "Country", "DiamondBusinessType", 
    "MemberStatus", "PrimaryCard", "Dual", "AutoCharge", "CreateDate", "UpdateDate"
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY "MembershipNumber") AS "DimMembershipCardId",
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
    "AutoCharge",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM (
    SELECT 
        CONCAT(MC."Cost_Center", MC."Account_Number", MC."Card_Number") AS "MembershipNumber",
        CONCAT(MC."Cost_Center", MC."Account_Number") AS "AccountNumberFull",
        MC."Cost_Center"::VARCHAR(4) AS "ClubNumber",
        MC."Card_Number"::VARCHAR(10) AS "CardNumber",
        MC."Block_Status"::VARCHAR(10) AS "BlockStatus",
        MC."Cancel_Date"::DATE AS "CancelDate",
        MC."Has_Cell_Phone"::VARCHAR(1) AS "HasCellPhone",
        MC."Has_Email"::VARCHAR(1) AS "HasEmail",
        MC."Mem_Event"::VARCHAR(10) AS "MemEvent",
        MC."Zone"::VARCHAR(20) AS "Zone",
        MC."Awareness_Code"::VARCHAR(10) AS "AwarenessCode",
        MC."Way_Of_Notification"::VARCHAR(20) AS "WayOfNotification",
        MC."Date_Of_Birth"::DATE AS "DateOfBirth",
        MC."Issued_Date"::DATE AS "IssuedDate",
        MC."Gender"::VARCHAR(1) AS "Gender",
        MC."Card_Type"::VARCHAR(10) AS "CardType",
        MC."Country"::VARCHAR(50) AS "Country",
        MC."Diamond_Business_Type"::VARCHAR(10) AS "DiamondBusinessType",
        MC."Member_Status"::VARCHAR(10) AS "MemberStatus",
        MC."Primary_Card"::VARCHAR(1) AS "PrimaryCard",
        MC."Dual"::VARCHAR(1) AS "Dual",
        MC."Auto_Charge"::VARCHAR(1) AS "AutoCharge"
    FROM "LakehouseAs400"."PROD_membership_cards" MC
) source_data;

-- Populate FactMembershipTransactions
INSERT INTO "Memberships"."FactMembershipTransactions" (
    "FactMembershipTransactionId", "DimClubNumberId", "DimMembershipAccountId", 
    "DimDateTransactionDateId", "DimDateEffectiveDateId", "DimDateExpiredDateId",
    "AccountNumber", "OrderNumber", "TransactionDate", "AccountType", "TransactionType",
    "ExpiredDate", "EffectiveDate", "HomeCostCenter", "PlatinumTransaction",
    "SalesOrderNumber", "InvoiceNumber", "TotalCost", "TotalUsdCostNet", "CreateDate", "UpdateDate"
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY "OrderNumber") AS "FactMembershipTransactionId",
    (SELECT "DimClubId" FROM "MasterData"."DimClubs" dc WHERE dc."ClubNumber" = t."Cost_Center" LIMIT 1) AS "DimClubNumberId",
    (SELECT "DimMembershipAccountId" FROM "Memberships"."DimMembershipAccounts" dma WHERE dma."AccountNumber" = t."Account_Number" LIMIT 1) AS "DimMembershipAccountId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = t."Transaction_Date" LIMIT 1) AS "DimDateTransactionDateId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = t."Effective_Date" LIMIT 1) AS "DimDateEffectiveDateId",
    (SELECT "DimDateId" FROM "MasterData"."DimDates" dd WHERE dd."Date" = t."Expired_Date" LIMIT 1) AS "DimDateExpiredDateId",
    t."Account_Number"::NUMERIC(6,0) AS "AccountNumber",
    t."Order_Number"::VARCHAR(20) AS "OrderNumber",
    t."Transaction_Date"::DATE AS "TransactionDate",
    t."Account_Type"::VARCHAR(2) AS "AccountType",
    t."Transaction_Type"::VARCHAR(20) AS "TransactionType",
    t."Expired_Date"::DATE AS "ExpiredDate",
    t."Effective_Date"::DATE AS "EffectiveDate",
    t."Home_Cost_Center"::VARCHAR(4) AS "HomeCostCenter",
    CASE 
        WHEN TRIM(t."Platinum_Transaction") = '' THEN NULL 
        ELSE t."Platinum_Transaction"::VARCHAR(1) 
    END AS "PlatinumTransaction",
    t."Sales_Order_Number"::VARCHAR(20) AS "SalesOrderNumber",
    t."Invoice_Number"::VARCHAR(20) AS "InvoiceNumber",
    t."Total_Cost"::DECIMAL(15,2) AS "TotalCost",
    t."Total_Usd_Cost_Net"::DECIMAL(15,2) AS "TotalUsdCostNet",
    CURRENT_TIMESTAMP AS "CreateDate",
    CURRENT_TIMESTAMP AS "UpdateDate"
FROM "LakehouseAs400"."PROD_membership_transactions_header" t
WHERE 
    t."Total_Usd_Cost_Net" IS NOT NULL AND t."Total_Cost" IS NOT NULL AND
    t."Cost_Center" IS NOT NULL AND t."Cost_Center" != '' AND
    t."Account_Type" IN ('DI', 'BS') AND
    t."Effective_Date" IS NOT NULL AND
    t."Expired_Date" IS NOT NULL AND
    t."Transaction_Date" > '2023-09-01';

\echo 'All tables populated with data successfully!'
