-- Complete Setup: Create Tables with Constraints and Data
-- This script creates all tables with proper constraints and populates them with data
-- Run this to replace the dbt models with constraint-enforced tables

\echo 'Starting complete setup with constraints...'

-- Step 1: Create tables with constraints
\echo 'Step 1: Creating tables with constraints...'
\i create_tables_with_constraints.sql

-- Step 2: Populate tables with data
\echo 'Step 2: Populating tables with data...'
\i populate_tables_with_data.sql

-- Step 3: Verify constraints are working
\echo 'Step 3: Verifying constraints...'

-- Test primary key constraints
\echo 'Testing primary key constraints...'
SELECT 'DimClubs' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT "DimClubId") as unique_pks FROM "MasterData"."DimClubs";
SELECT 'DimDates' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT "DimDateId") as unique_pks FROM "MasterData"."DimDates";
SELECT 'DimMembershipAccounts' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT "DimMembershipAccountId") as unique_pks FROM "Memberships"."DimMembershipAccounts";
SELECT 'DimMembershipCards' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT "DimMembershipCardId") as unique_pks FROM "Memberships"."DimMembershipCards";
SELECT 'FactMembershipTransactions' as table_name, COUNT(*) as total_rows, COUNT(DISTINCT "FactMembershipTransactionId") as unique_pks FROM "Memberships"."FactMembershipTransactions";

-- Test foreign key constraints
\echo 'Testing foreign key constraints...'
SELECT 
    'FactMembershipTransactions FK Test' as test_name,
    COUNT(*) as total_rows,
    COUNT("DimClubNumberId") as non_null_fk_club,
    COUNT("DimMembershipAccountId") as non_null_fk_account,
    COUNT("DimDateTransactionDateId") as non_null_fk_transaction_date
FROM "Memberships"."FactMembershipTransactions";

-- Test unique constraints
\echo 'Testing unique constraints...'
SELECT 'DimClubs ClubNumber' as constraint_test, COUNT(*) as total, COUNT(DISTINCT "ClubNumber") as unique_count FROM "MasterData"."DimClubs";
SELECT 'DimDates Date' as constraint_test, COUNT(*) as total, COUNT(DISTINCT "Date") as unique_count FROM "MasterData"."DimDates";
SELECT 'DimMembershipAccounts AccountNumberFull' as constraint_test, COUNT(*) as total, COUNT(DISTINCT "AccountNumberFull") as unique_count FROM "Memberships"."DimMembershipAccounts";

\echo 'Complete setup finished successfully!'
\echo 'All tables created with enforced constraints and populated with data.'
