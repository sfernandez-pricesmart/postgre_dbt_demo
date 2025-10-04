#!/bin/bash

echo "🧹 Cleaning up PostgreSQL dbt environment..."

# Stop and remove containers
echo "🛑 Stopping containers..."
docker-compose down

# Remove volumes (optional - uncomment if you want to delete all data)
# echo "🗑️ Removing volumes..."
# docker volume rm postgresql-dbt-setup_postgres_data

echo "✅ Cleanup complete!"
echo ""
echo "💡 To completely remove all data, uncomment the volume removal lines in cleanup.sh"
