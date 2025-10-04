-- Create Tables with Keys and Constraints
-- This script creates all dimension and fact tables with proper constraints
-- Run this after dbt run to recreate tables with enforced constraints

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS "Memberships"."FactMembershipTransactions" CASCADE;
DROP TABLE IF EXISTS "Memberships"."DimMembershipCards" CASCADE;
DROP TABLE IF EXISTS "Memberships"."DimMembershipAccounts" CASCADE;
DROP TABLE IF EXISTS "MasterData"."DimDates" CASCADE;
DROP TABLE IF EXISTS "MasterData"."DimClubs" CASCADE;

-- Create DimClubs table with constraints
CREATE TABLE "MasterData"."DimClubs" (
    "DimClubId" BIGINT NOT NULL,
    "ClubNumber" VARCHAR(4) NOT NULL,
    "ClubName" VARCHAR(50) NOT NULL,
    "Country" VARCHAR(3) NOT NULL,
    "Zone" VARCHAR(3),
    "Status" VARCHAR(1) NOT NULL,
    "CreateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "UpdateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Primary Key
    CONSTRAINT "pk_dimclubs" PRIMARY KEY ("DimClubId"),
    
    -- Unique Constraints
    CONSTRAINT "uk_dimclubs_clubnumber" UNIQUE ("ClubNumber"),
    
    -- Check Constraints
    CONSTRAINT "ck_dimclubs_status" CHECK ("Status" IN ('A', 'I'))
);

-- Create DimDates table with constraints
CREATE TABLE "MasterData"."DimDates" (
    "DimDateId" BIGINT NOT NULL,
    "Date" DATE NOT NULL,
    "Year" INTEGER NOT NULL,
    "Month" INTEGER NOT NULL,
    "Day" INTEGER NOT NULL,
    "Quarter" INTEGER NOT NULL,
    "Week" INTEGER NOT NULL,
    "DayOfWeek" INTEGER NOT NULL,
    "IsWeekend" BOOLEAN NOT NULL,
    "IsHoliday" BOOLEAN NOT NULL,
    "CreateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "UpdateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Primary Key
    CONSTRAINT "pk_dimdates" PRIMARY KEY ("DimDateId"),
    
    -- Unique Constraints
    CONSTRAINT "uk_dimdates_date" UNIQUE ("Date")
);

-- Create DimMembershipAccounts table with constraints
CREATE TABLE "Memberships"."DimMembershipAccounts" (
    "DimMembershipAccountId" BIGINT NOT NULL,
    "AccountNumberFull" VARCHAR(20) NOT NULL,
    "ClubNumber" VARCHAR(4) NOT NULL,
    "HomeClubNumber" VARCHAR(4),
    "AccountType" VARCHAR(2) NOT NULL,
    "AccountNumber" NUMERIC(6,0) NOT NULL,
    "Complimentary" VARCHAR(1),
    "DateAccountOpened" DATE,
    "EffectiveDate" DATE,
    "ExpirationDate" DATE,
    "CancelDate" DATE,
    "BusinessName" VARCHAR(100),
    "BSBusinessType" VARCHAR(10),
    "PlatinumAccount" VARCHAR(1) NOT NULL,
    "NumberOfEmployees" INTEGER,
    "BusinessLicenseNumber" TEXT,
    "CreateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "UpdateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Primary Key
    CONSTRAINT "pk_dimmembershipaccounts" PRIMARY KEY ("DimMembershipAccountId"),
    
    -- Unique Constraints
    CONSTRAINT "uk_dimmembershipaccounts_accountnumberfull" UNIQUE ("AccountNumberFull"),
    
    -- Check Constraints
    CONSTRAINT "ck_dimmembershipaccounts_accounttype" CHECK ("AccountType" IN ('DI', 'BS'))
);

-- Create DimMembershipCards table with constraints
CREATE TABLE "Memberships"."DimMembershipCards" (
    "DimMembershipCardId" BIGINT NOT NULL,
    "MembershipNumber" VARCHAR(30) NOT NULL,
    "AccountNumberFull" VARCHAR(20) NOT NULL,
    "ClubNumber" VARCHAR(4) NOT NULL,
    "CardNumber" VARCHAR(10) NOT NULL,
    "BlockStatus" VARCHAR(10),
    "CancelDate" DATE,
    "HasCellPhone" VARCHAR(1) NOT NULL,
    "HasEmail" VARCHAR(1) NOT NULL,
    "MemEvent" VARCHAR(10),
    "Zone" VARCHAR(20),
    "AwarenessCode" VARCHAR(10),
    "WayOfNotification" VARCHAR(20),
    "DateOfBirth" DATE,
    "IssuedDate" DATE,
    "Gender" VARCHAR(1),
    "CardType" VARCHAR(10),
    "Country" VARCHAR(50),
    "DiamondBusinessType" VARCHAR(10),
    "MemberStatus" VARCHAR(10),
    "PrimaryCard" VARCHAR(1) NOT NULL,
    "Dual" VARCHAR(1),
    "AutoCharge" VARCHAR(1),
    "CreateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "UpdateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Primary Key
    CONSTRAINT "pk_dimmembershipcards" PRIMARY KEY ("DimMembershipCardId"),
    
    -- Unique Constraints
    CONSTRAINT "uk_dimmembershipcards_membershipnumber" UNIQUE ("MembershipNumber")
);

-- Create FactMembershipTransactions table with constraints
CREATE TABLE "Memberships"."FactMembershipTransactions" (
    "FactMembershipTransactionId" BIGINT NOT NULL,
    "DimClubNumberId" BIGINT NOT NULL,
    "DimMembershipAccountId" BIGINT NOT NULL,
    "DimDateTransactionDateId" BIGINT NOT NULL,
    "DimDateEffectiveDateId" BIGINT,
    "DimDateExpiredDateId" BIGINT,
    "AccountNumber" NUMERIC(6,0) NOT NULL,
    "OrderNumber" VARCHAR(20) NOT NULL,
    "TransactionDate" DATE NOT NULL,
    "AccountType" VARCHAR(2) NOT NULL,
    "TransactionType" VARCHAR(20) NOT NULL,
    "ExpiredDate" DATE,
    "EffectiveDate" DATE NOT NULL,
    "HomeCostCenter" VARCHAR(4),
    "PlatinumTransaction" VARCHAR(1),
    "SalesOrderNumber" VARCHAR(20),
    "InvoiceNumber" VARCHAR(20),
    "TotalCost" DECIMAL(15,2) NOT NULL,
    "TotalUsdCostNet" DECIMAL(15,2) NOT NULL,
    "CreateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "UpdateDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Primary Key
    CONSTRAINT "pk_factmembershiptransactions" PRIMARY KEY ("FactMembershipTransactionId"),
    
    -- Unique Constraints
    CONSTRAINT "uk_factmembershiptransactions_ordernumber" UNIQUE ("OrderNumber"),
    
    -- Foreign Key Constraints
    CONSTRAINT "fk_factmembershiptransactions_dimclubnumberid" 
        FOREIGN KEY ("DimClubNumberId") REFERENCES "MasterData"."DimClubs"("DimClubId"),
    CONSTRAINT "fk_factmembershiptransactions_dimmembershipaccountid" 
        FOREIGN KEY ("DimMembershipAccountId") REFERENCES "Memberships"."DimMembershipAccounts"("DimMembershipAccountId"),
    CONSTRAINT "fk_factmembershiptransactions_dimdatetransactiondateid" 
        FOREIGN KEY ("DimDateTransactionDateId") REFERENCES "MasterData"."DimDates"("DimDateId"),
    CONSTRAINT "fk_factmembershiptransactions_dimdateeffectivedateid" 
        FOREIGN KEY ("DimDateEffectiveDateId") REFERENCES "MasterData"."DimDates"("DimDateId"),
    CONSTRAINT "fk_factmembershiptransactions_dimdateexpireddateid" 
        FOREIGN KEY ("DimDateExpiredDateId") REFERENCES "MasterData"."DimDates"("DimDateId"),
    
    -- Check Constraints
    CONSTRAINT "ck_factmembershiptransactions_accounttype" CHECK ("AccountType" IN ('DI', 'BS')),
    CONSTRAINT "ck_factmembershiptransactions_positive_amounts" 
        CHECK ("TotalCost" >= 0 AND "TotalUsdCostNet" >= 0)
);

-- Create indexes for better performance
CREATE INDEX "idx_dimclubs_clubnumber" ON "MasterData"."DimClubs" ("ClubNumber");
CREATE INDEX "idx_dimdates_date" ON "MasterData"."DimDates" ("Date");
CREATE INDEX "idx_dimmembershipaccounts_accountnumberfull" ON "Memberships"."DimMembershipAccounts" ("AccountNumberFull");
CREATE INDEX "idx_dimmembershipcards_membershipnumber" ON "Memberships"."DimMembershipCards" ("MembershipNumber");
CREATE INDEX "idx_factmembershiptransactions_ordernumber" ON "Memberships"."FactMembershipTransactions" ("OrderNumber");

-- Create foreign key indexes for better performance
CREATE INDEX "idx_factmembershiptransactions_dimclubnumberid" ON "Memberships"."FactMembershipTransactions" ("DimClubNumberId");
CREATE INDEX "idx_factmembershiptransactions_dimmembershipaccountid" ON "Memberships"."FactMembershipTransactions" ("DimMembershipAccountId");
CREATE INDEX "idx_factmembershiptransactions_dimdatetransactiondateid" ON "Memberships"."FactMembershipTransactions" ("DimDateTransactionDateId");
CREATE INDEX "idx_factmembershiptransactions_dimdateeffectivedateid" ON "Memberships"."FactMembershipTransactions" ("DimDateEffectiveDateId");
CREATE INDEX "idx_factmembershiptransactions_dimdateexpireddateid" ON "Memberships"."FactMembershipTransactions" ("DimDateExpiredDateId");

\echo 'All tables created with constraints successfully!'
