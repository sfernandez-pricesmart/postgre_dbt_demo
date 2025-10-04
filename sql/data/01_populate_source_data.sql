-- Populate source tables with sample data
-- This simulates the AS400 data that would be loaded

-- Insert sample membership cards data
INSERT INTO "LakehouseAs400"."PROD_membership_cards" VALUES
('0001', '123456', '0001', '01', '2023-12-31', 'Y', 'Y', 'EV01', 'Z01', 'AW01', 'WN01', '1990-01-15', '2023-01-01', 'M', '01', 'USA', 'DB01', '01', 'Y', 'D01', 'AC01'),
('0001', '123456', '0002', '01', NULL, 'N', 'Y', 'EV02', 'Z01', 'AW02', 'WN02', '1985-05-20', '2023-01-01', 'F', '02', 'USA', 'DB02', '01', 'N', 'D02', 'AC02'),
('0002', '789012', '0001', '02', NULL, 'Y', 'N', 'EV01', 'Z02', 'AW01', 'WN01', '1992-03-10', '2023-02-01', 'M', '01', 'CAN', 'DB01', '02', 'Y', 'D01', 'AC01'),
('0002', '789012', '0002', '02', NULL, 'N', 'Y', 'EV03', 'Z02', 'AW03', 'WN03', '1988-11-25', '2023-02-01', 'F', '03', 'CAN', 'DB03', '02', 'N', 'D03', 'AC03');

-- Insert sample membership accounts data
INSERT INTO "LakehouseAs400"."PROD_membership_accounts" VALUES
('0001', '123456', '0001', 'DI', 'N', '2023-01-01', '2023-01-01', '2024-12-31', NULL, 'Sample Business Inc', 'BS1', 'N', 50, 'BL123456789'),
('0001', '123456', '0001', 'DI', 'Y', '2023-01-01', '2023-01-01', '2024-12-31', NULL, '', 'BS2', 'Y', 25, ''),
('0002', '789012', '0002', 'BS', 'N', '2023-02-01', '2023-02-01', '2024-12-31', NULL, 'Another Business LLC', 'BS3', 'N', 100, 'BL987654321'),
('0002', '789012', '0002', 'BS', 'N', '2023-02-01', '2023-02-01', '2024-12-31', NULL, 'Third Business Corp', 'BS1', 'Y', 200, 'BL555666777');

-- Insert sample membership transactions data
INSERT INTO "LakehouseAs400"."PROD_membership_transactions_header" VALUES
('0001', '123456', '00000001', '2023-01-15', 'DI', 'T01', '2024-01-15', '2023-01-15', '0001', 'PT1', '00000001', '00000001', 100.00, 100.00),
('0001', '123456', '00000002', '2023-02-15', 'DI', 'T02', '2024-02-15', '2023-02-15', '0001', '', '00000002', '00000002', 150.00, 150.00),
('0002', '789012', '00000003', '2023-03-15', 'BS', 'T01', '2024-03-15', '2023-03-15', '0002', 'PT2', '00000003', '00000003', 200.00, 200.00),
('0002', '789012', '00000004', '2023-04-15', 'BS', 'T03', '2024-04-15', '2023-04-15', '0002', '', '00000004', '00000004', 75.00, 75.00);

-- Insert sample clubs data
INSERT INTO "LakehouseAs400"."PROD_clubs" VALUES
('0001', 'Downtown Club', 'USA', 'Z01', 'A'),
('0002', 'Uptown Club', 'CAN', 'Z02', 'A'),
('0003', 'Suburban Club', 'USA', 'Z01', 'A'),
('0004', 'Metro Club', 'MEX', 'Z03', 'A');

-- Insert sample dates data (last 2 years)
INSERT INTO "LakehouseAs400"."PROD_dates" 
SELECT 
    date_series as "Date",
    EXTRACT(YEAR FROM date_series) as "Year",
    EXTRACT(MONTH FROM date_series) as "Month",
    EXTRACT(DAY FROM date_series) as "Day",
    EXTRACT(QUARTER FROM date_series) as "Quarter",
    EXTRACT(WEEK FROM date_series) as "Week",
    EXTRACT(DOW FROM date_series) as "Day_of_Week",
    CASE WHEN EXTRACT(DOW FROM date_series) IN (0, 6) THEN TRUE ELSE FALSE END as "Is_Weekend",
    FALSE as "Is_Holiday"
FROM generate_series(
    CURRENT_DATE - INTERVAL '2 years',
    CURRENT_DATE + INTERVAL '1 year',
    INTERVAL '1 day'
) as date_series;
