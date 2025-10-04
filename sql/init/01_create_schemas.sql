-- Create schemas for the dimensional model
CREATE SCHEMA IF NOT EXISTS "LakehouseAs400";
CREATE SCHEMA IF NOT EXISTS "Memberships";
CREATE SCHEMA IF NOT EXISTS "MasterData";
CREATE SCHEMA IF NOT EXISTS "Stages";

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA "LakehouseAs400" TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA "Memberships" TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA "MasterData" TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA "Stages" TO postgres;
