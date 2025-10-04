# PostgreSQL dbt Setup - Elysium Dev Dimensional Model

This project replicates the Snowflake Elysium dimensional model using PostgreSQL and dbt, with Docker containerization for easy setup and deployment.

## 🏗️ Architecture

### Data Flow
```
AS400 Source Data → PostgreSQL → dbt Staging → dbt Dimensional Models
```

### Schema Structure
- **LakehouseAs400**: Raw source data from AS400 system
- **Stages**: Ephemeral staging models with data transformations
- **Memberships**: Dimensional models for membership data
- **MasterData**: Master data dimensional models

## 📁 Project Structure

```
postgresql-dbt-setup/
├── docker-compose.yml          # Docker orchestration
├── Dockerfile.dbt              # dbt container configuration
├── requirements.txt            # Python dependencies
├── setup.sh                   # Initial setup script
├── run_dbt.sh                 # Run dbt commands
├── cleanup.sh                 # Cleanup script
├── README.md                  # This file
├── dbt_project/               # dbt project files
│   ├── dbt_project.yml        # dbt project configuration
│   ├── profiles.yml           # dbt connection profiles
│   ├── macros/                # dbt macros
│   │   └── convert_empty_string_to_null.sql
│   └── models/                # dbt models
│       ├── Lakehouse/         # Source definitions
│       ├── Stages/            # Staging models
│       ├── Memberships/       # Membership dimensional models
│       └── MasterData/        # Master data dimensional models
└── sql/                       # SQL initialization scripts
    ├── init/                  # Database setup scripts
    └── data/                  # Sample data population
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git (to clone the repository)

### Setup
1. **Clone and navigate to the project:**
   ```bash
   cd postgresql-dbt-setup
   ```

2. **Run the setup script:**
   ```bash
   ./setup.sh
   ```

3. **Verify the setup:**
   ```bash
   docker ps
   ```

### Running dbt Commands
```bash
# Run all models
./run_dbt.sh

# Or run individual dbt commands
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt run"
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt test"
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt docs serve"
```

### Running SQL Files

#### Database Setup Scripts
```bash
# Create source tables with audit columns
docker exec postgres_dbt psql -U postgres -d elysium_dev -f /docker-entrypoint-initdb.d/02_create_source_tables.sql

# Populate source tables with sample data
docker exec postgres_dbt psql -U postgres -d elysium_dev -f /docker-entrypoint-initdb.d/data/01_populate_source_data.sql

# Create dimensional tables with constraints
docker exec postgres_dbt psql -U postgres -d elysium_dev -f /docker-entrypoint-initdb.d/constraints/create_tables_with_constraints.sql
```

#### Simulation Scenarios
```bash
# Run new transactions scenario
docker exec postgres_dbt psql -U postgres -d elysium_dev -f /docker-entrypoint-initdb.d/scenarios/01_new_transactions_scenario.sql
```

#### Direct SQL Execution
```bash
# Execute SQL commands directly
docker exec postgres_dbt psql -U postgres -d elysium_dev -c "SELECT COUNT(*) FROM \"LakehouseAs400\".\"PROD_clubs\";"

# Connect to PostgreSQL interactively
docker exec -it postgres_dbt psql -U postgres -d elysium_dev
```

## 🗄️ Database Schema

### Source Tables (LakehouseAs400 schema)
- **PROD_membership_cards**: Raw membership cards data
- **PROD_membership_accounts**: Raw membership accounts data
- **PROD_membership_transactions_header**: Raw transaction data
- **PROD_clubs**: Raw clubs data
- **PROD_dates**: Date dimension source data

### Staging Models (Ephemeral)
- **StgDimMembershipCards**: Transformed membership cards
- **StgDimMembershipAccounts**: Transformed membership accounts
- **StgFactMembershipTransactions**: Transformed transactions
- **StgDimClubs**: Transformed clubs data
- **StgDimDates**: Transformed dates data

### Dimensional Models
#### Memberships Schema
- **DimMembershipCards**: Membership cards dimension
- **DimMembershipAccounts**: Membership accounts dimension
- **FactMembershipTransactions**: Membership transactions fact table

#### MasterData Schema
- **DimClubs**: Clubs dimension
- **DimDates**: Date dimension

## 🔧 Key Features

### Empty String to NULL Conversion
The project includes a reusable macro `convert_empty_string_to_null` that:
- Converts empty strings to NULL values
- Maintains data type casting
- Ensures consistent data quality
- Can be applied across all models

### Data Quality Transformations
- **Data Type Casting**: Proper casting to appropriate data types
- **String Cleaning**: TRIM operations and empty string handling
- **Business Logic**: Account type filtering, date range filtering
- **Deduplication**: ROW_NUMBER() for handling duplicates

## 🧪 Testing

### Run Tests
```bash
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt test"
```

### Available Tests
- **Source Tests**: Not null, unique constraints on source tables
- **Model Tests**: Data quality validations
- **Custom Tests**: Business logic validations

## 📊 Sample Data

The setup includes sample data that simulates:
- **Membership Cards**: 4 sample cards across 2 accounts
- **Membership Accounts**: 4 sample accounts with business information
- **Transactions**: 4 sample transactions with various types
- **Clubs**: 4 sample clubs across different countries
- **Dates**: 3 years of date dimension data

## 🔍 Data Exploration

### Connect to PostgreSQL
```bash
# Using psql
docker exec -it postgres_dbt psql -U postgres -d elysium_dev

# Or using any PostgreSQL client
# Host: localhost
# Port: 5432
# Database: elysium_dev
# Username: postgres
# Password: postgres
```

### Query Examples
```sql
-- View all schemas
SELECT schema_name FROM information_schema.schemata;

-- View source data
SELECT * FROM "LakehouseAs400"."PROD_membership_cards" LIMIT 5;

-- View dimensional models
SELECT * FROM "Memberships"."DimMembershipAccounts" LIMIT 5;
SELECT * FROM "Memberships"."FactMembershipTransactions" LIMIT 5;
```

## 🛠️ Development

### Adding New Models
1. Create SQL file in appropriate directory (`models/Stages/`, `models/Memberships/`, etc.)
2. Add model configuration in `dbt_project.yml`
3. Run `dbt run` to test

### Adding New Macros
1. Create SQL file in `macros/` directory
2. Use `{{ macro_name() }}` in models
3. Test with `dbt run`

### Modifying Source Data
1. Update SQL files in `sql/data/` directory
2. Rebuild containers: `docker-compose down && docker-compose up -d --build`

## 🧹 Cleanup

### Stop and Remove Containers
```bash
./cleanup.sh
```

### Complete Cleanup (Remove All Data)
```bash
docker-compose down
docker volume rm postgresql-dbt-setup_postgres_data
docker system prune -f
```

## 📚 dbt Documentation

### Generate Documentation
```bash
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt docs generate"
```

### Serve Documentation
```bash
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt docs serve"
```

## 🔧 Troubleshooting

### Common Issues

1. **Container not starting:**
   ```bash
   docker-compose logs postgres
   docker-compose logs dbt
   ```

2. **dbt connection issues:**
   ```bash
   docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt debug"
   ```

3. **Database connection issues:**
   ```bash
   docker exec postgres_dbt pg_isready -U postgres
   ```

### Reset Everything
```bash
./cleanup.sh
docker system prune -f
./setup.sh
```

## 📈 Performance Considerations

- **Staging Models**: Configured as ephemeral for better performance
- **Dimensional Models**: Materialized as tables for query performance
- **Indexing**: Consider adding indexes on frequently queried columns
- **Partitioning**: For large fact tables, consider date-based partitioning

## 🔒 Security Notes

- Default credentials are for development only
- Change passwords for production use
- Consider using environment variables for sensitive data
- Implement proper network security for production deployments

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review dbt documentation: https://docs.getdbt.com/
3. Check Docker logs for container issues
4. Verify database connectivity and permissions
