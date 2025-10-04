#!/bin/bash

echo "🔧 Running dbt commands..."

# Check if containers are running
if ! docker ps | grep -q "dbt_workspace"; then
    echo "❌ dbt container is not running. Please run setup.sh first."
    exit 1
fi

if ! docker ps | grep -q "postgres_dbt"; then
    echo "❌ PostgreSQL container is not running. Please run setup.sh first."
    exit 1
fi

# Run dbt commands
echo "📊 Running dbt models..."
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt run"

echo "🧪 Running dbt tests..."
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt test"

echo "📚 Generating dbt docs..."
docker exec dbt_workspace bash -c "cd /app/dbt_project && dbt docs generate"

echo "✅ dbt run complete!"
