{{
  config(
    materialized='ephemeral'
  )
}}

SELECT 
    -- Data type casting and transformations
    CONCAT(TRIM(c."Cost_Center"),
           RIGHT(CONCAT('000000', TRIM(c."Account_Number")),6),
           RIGHT(CONCAT('0000', TRIM(c."Card_Number")),4))::INTEGER AS "MembershipNumber",
    CONCAT(TRIM(c."Cost_Center"), 
           RIGHT(CONCAT('000000', 
           TRIM(c."Account_Number")), 6))::INTEGER AS "AccountNumberFull",
    c."Cost_Center"::VARCHAR(4) AS "ClubNumber",
    c."Card_Number"::NUMERIC(4) AS "CardNumber",
    c."Block_Status"::VARCHAR(2) AS "BlockStatus",
    c."Cancel_Date"::DATE AS "CancelDate",
    CASE WHEN c."Cell_Phone_YN" = 'Y' THEN TRUE ELSE FALSE END AS "HasCellPhone",
    CASE WHEN c."Email_YN" = 'Y' THEN TRUE ELSE FALSE END AS "HasEmail",
    c."Mem_Event"::VARCHAR(4) AS "MemEvent",
    c."Zone"::VARCHAR(3) AS "Zone",
    c."Awareness_Code"::VARCHAR(4) AS "AwarenessCode",
    c."Way_of_Notification"::VARCHAR(4) AS "WayOfNotification",
    c."Date_of_Birth"::VARCHAR(10) AS "DateOfBirth",
    c."Issued_Date"::DATE AS "IssuedDate",
    c."Gender"::VARCHAR(1) AS "Gender",
    c."Card_Type"::VARCHAR(2) AS "CardType",
    c."Country"::VARCHAR(3) AS "Country",
    c."Diamond_Business_Type"::VARCHAR(4) AS "DiamondBusinessType",
    c."Member_Status"::VARCHAR(2) AS "MemberStatus",
    CASE WHEN c."Primary_Card" = 'Y' THEN TRUE ELSE FALSE END AS "PrimaryCard",
    c."Dual"::VARCHAR(3) AS "Dual",
    c."Auto_Charge"::VARCHAR(3) AS "AutoCharge"
    
FROM {{ source('LakehouseAs400', 'PROD_membership_cards') }} c
