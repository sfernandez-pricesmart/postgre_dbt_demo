-- Create source tables in LakehouseAs400 schema
-- These represent the raw data from AS400 system

-- Membership Cards Source Table
CREATE TABLE IF NOT EXISTS "LakehouseAs400"."PROD_membership_cards" (
    "Cost_Center" VARCHAR(4),
    "Account_Number" VARCHAR(6),
    "Card_Number" VARCHAR(4),
    "Block_Status" VARCHAR(2),
    "Cancel_Date" DATE,
    "Cell_Phone_YN" VARCHAR(1),
    "Email_YN" VARCHAR(1),
    "Mem_Event" VARCHAR(4),
    "Zone" VARCHAR(3),
    "Awareness_Code" VARCHAR(4),
    "Way_of_Notification" VARCHAR(4),
    "Date_of_Birth" VARCHAR(10),
    "Issued_Date" DATE,
    "Gender" VARCHAR(1),
    "Card_Type" VARCHAR(2),
    "Country" VARCHAR(3),
    "Diamond_Business_Type" VARCHAR(4),
    "Member_Status" VARCHAR(2),
    "Primary_Card" VARCHAR(1),
    "Dual" VARCHAR(3),
    "Auto_Charge" VARCHAR(3)
);

-- Membership Accounts Source Table
CREATE TABLE IF NOT EXISTS "LakehouseAs400"."PROD_membership_accounts" (
    "Cost_Center" VARCHAR(4),
    "Account_Number" VARCHAR(6),
    "Home_Business_Unit" VARCHAR(4),
    "Account_Type" VARCHAR(2),
    "Complimentary" VARCHAR(1),
    "Date_Account_Opened" DATE,
    "Effective_Date" DATE,
    "Expiration_Date" DATE,
    "Cancel_Date" DATE,
    "Business_Name" VARCHAR(60),
    "BS_Business_Type" VARCHAR(3),
    "Platinum_Account" VARCHAR(1),
    "Number_of_Employees" NUMERIC(15,0),
    "Business_License_Number" VARCHAR(16777216)
);

-- Membership Transactions Source Table
CREATE TABLE IF NOT EXISTS "LakehouseAs400"."PROD_membership_transactions_header" (
    "Cost_Center" VARCHAR(4),
    "Account_Number" VARCHAR(6),
    "Order_Number" VARCHAR(8),
    "Transaction_Date" DATE,
    "Account_Type" VARCHAR(2),
    "Transaction_Type" VARCHAR(3),
    "Expired_Date" DATE,
    "Effective_Date" DATE,
    "Home_Cost_Center" VARCHAR(4),
    "Platinum_Transaction" VARCHAR(3),
    "Sales_Order_Number" VARCHAR(8),
    "Invoice_Number" VARCHAR(8),
    "Total_Cost" NUMERIC(15,2),
    "Total_Usd_Cost_Net" NUMERIC(15,2)
);

-- Clubs Source Table
CREATE TABLE IF NOT EXISTS "LakehouseAs400"."PROD_clubs" (
    "Club_Number" VARCHAR(4),
    "Club_Name" VARCHAR(50),
    "Country" VARCHAR(3),
    "Zone" VARCHAR(3),
    "Status" VARCHAR(1)
);

-- Dates Source Table (for date dimension)
CREATE TABLE IF NOT EXISTS "LakehouseAs400"."PROD_dates" (
    "Date" DATE,
    "Year" INTEGER,
    "Month" INTEGER,
    "Day" INTEGER,
    "Quarter" INTEGER,
    "Week" INTEGER,
    "Day_of_Week" INTEGER,
    "Is_Weekend" BOOLEAN,
    "Is_Holiday" BOOLEAN
);
