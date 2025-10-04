-- Simulation Scenario: Insert New Membership Transactions
-- This script simulates new transaction data being loaded into the system
-- with current timestamps for created_at and updated_at

-- Insert new membership transactions with current timestamp
INSERT INTO "LakehouseAs400"."PROD_membership_transactions_header" VALUES
-- New transactions for existing accounts
('0001', '123456', '00000005', '2024-12-19', 'DI', 'T01', '2025-12-19', '2024-12-19', '0001', 'PT1', '00000005', '00000005', 250.00, 250.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0001', '123456', '00000006', '2024-12-19', 'DI', 'T03', '2025-12-19', '2024-12-19', '0001', '', '00000006', '00000006', 175.50, 175.50, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0002', '789012', '00000007', '2024-12-19', 'BS', 'T02', '2025-12-19', '2024-12-19', '0002', 'PT2', '00000007', '00000007', 300.00, 300.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0002', '789012', '00000008', '2024-12-19', 'BS', 'T01', '2025-12-19', '2024-12-19', '0002', '', '00000008', '00000008', 125.75, 125.75, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- New transactions for new accounts (simulating new members)
('0003', '345678', '00000009', '2024-12-19', 'DI', 'T01', '2025-12-19', '2024-12-19', '0003', 'PT1', '00000009', '00000009', 400.00, 400.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0003', '345678', '00000010', '2024-12-19', 'DI', 'T02', '2025-12-19', '2024-12-19', '0003', '', '00000010', '00000010', 225.00, 225.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0004', '901234', '00000011', '2024-12-19', 'BS', 'T03', '2025-12-19', '2024-12-19', '0004', 'PT3', '00000011', '00000011', 500.00, 500.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('0004', '901234', '00000012', '2024-12-19', 'BS', 'T01', '2025-12-19', '2024-12-19', '0004', '', '00000012', '00000012', 350.25, 350.25, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Display summary of inserted records
SELECT 
    'New Transactions Inserted' as "Summary",
    COUNT(*) as "Record_Count",
    MIN("created_at") as "Earliest_Created",
    MAX("created_at") as "Latest_Created"
FROM "LakehouseAs400"."PROD_membership_transactions_header" 
WHERE "created_at" >= CURRENT_DATE;

-- Show the new records
SELECT 
    "Cost_Center",
    "Account_Number", 
    "Order_Number",
    "Transaction_Date",
    "Account_Type",
    "Transaction_Type",
    "Total_Cost",
    "Total_Usd_Cost_Net",
    "created_at",
    "updated_at"
FROM "LakehouseAs400"."PROD_membership_transactions_header" 
WHERE "created_at" >= CURRENT_DATE
ORDER BY "created_at" DESC;
