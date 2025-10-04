#!/bin/bash

echo "🚀 Setting up PostgreSQL dbt environment..."

# Create necessary directories
mkdir -p dbt_project/{models,analyses,tests,seeds,snapshots,macros}
mkdir -p dbt_project/models/{Lakehouse,Memberships,MasterData,Stages}
mkdir -p sql/{init,data}

# Build and start containers
echo "📦 Building and starting Docker containers..."
docker-compose up -d --build

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

# Check if PostgreSQL is ready
until docker exec postgres_dbt pg_isready -U postgres; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# Run dbt commands
echo "🔧 Setting up dbt project..."
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt deps"
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt debug"
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt seed"
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt run"

echo "🎉 Setup complete!"
echo ""
echo "📊 You can now:"
echo "  - Access PostgreSQL: localhost:5432 (user: postgres, password: postgres, db: elysium_dev)"
echo "  - Run dbt commands: docker exec dbt_workspace bash -c 'cd /app/dbt_project && dbt run'"
echo "  - View dbt docs: docker exec dbt_workspace bash -c 'cd /app/dbt_project && dbt docs serve'"
