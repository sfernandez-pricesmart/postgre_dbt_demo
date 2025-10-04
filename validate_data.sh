#!/bin/bash

echo "🔍 Validating data in PostgreSQL dbt setup..."

# Check if containers are running
if ! docker ps | grep -q "postgres_dbt"; then
    echo "❌ PostgreSQL container is not running. Please run setup.sh first."
    exit 1
fi

echo "📊 Checking source data..."
echo "================================"

# Check source table counts
echo "Source Tables:"
docker exec postgres_dbt psql -U postgres -d elysium_dev -c "
SELECT 
    schemaname,
    tablename,
    n_tup_ins as row_count
FROM pg_stat_user_tables 
WHERE schemaname = 'LakehouseAs400'
ORDER BY tablename;
"

echo ""
echo "📊 Checking staging models..."
echo "================================"

# Check if staging models exist (they should be ephemeral, so we check the source)
echo "Staging models are ephemeral - checking source data quality..."

echo ""
echo "📊 Checking dimensional models..."
echo "================================"

# Check dimensional model counts
echo "Dimensional Models:"
docker exec postgres_dbt psql -U postgres -d elysium_dev -c "
SELECT 
    schemaname,
    tablename,
    n_tup_ins as row_count
FROM pg_stat_user_tables 
WHERE schemaname IN ('Memberships', 'MasterData')
ORDER BY schemaname, tablename;
"

echo ""
echo "📊 Data Quality Checks..."
echo "================================"

# Check for empty strings in key columns
echo "Checking for empty strings in source data:"
docker exec postgres_dbt psql -U postgres -d elysium_dev -c "
SELECT 
    'PROD_membership_accounts' as table_name,
    'Business_Name' as column_name,
    COUNT(*) as empty_count
FROM \"LakehouseAs400\".\"PROD_membership_accounts\" 
WHERE TRIM(\"Business_Name\") = ''
UNION ALL
SELECT 
    'PROD_membership_transactions_header' as table_name,
    'Platinum_Transaction' as column_name,
    COUNT(*) as empty_count
FROM \"LakehouseAs400\".\"PROD_membership_transactions_header\" 
WHERE TRIM(\"Platinum_Transaction\") = '';
"

echo ""
echo "📊 Checking NULL values in dimensional models..."
echo "================================"

# Check NULL values in dimensional models
echo "NULL values in dimensional models:"
docker exec postgres_dbt psql -U postgres -d elysium_dev -c "
SELECT 
    'DimMembershipAccounts' as table_name,
    'BusinessName' as column_name,
    COUNT(*) as null_count
FROM \"Memberships\".\"DimMembershipAccounts\" 
WHERE \"BusinessName\" IS NULL
UNION ALL
SELECT 
    'FactMembershipTransactions' as table_name,
    'PlatinumTransaction' as column_name,
    COUNT(*) as null_count
FROM \"Memberships\".\"FactMembershipTransactions\" 
WHERE \"PlatinumTransaction\" IS NULL;
"

echo ""
echo "✅ Data validation complete!"
echo ""
echo "💡 Key Points:"
echo "  - Source data should have some empty strings"
echo "  - Dimensional models should have NULL values instead of empty strings"
echo "  - This demonstrates the empty string to NULL conversion is working"
