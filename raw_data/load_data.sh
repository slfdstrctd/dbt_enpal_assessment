#!/bin/bash

# Wait until PostgreSQL is ready
until pg_isready -h db -U admin; do
  echo "Waiting for database connection..."
  sleep 2
done

# Load each CSV file into its corresponding table.
# Truncate first so re-running the loader is idempotent (COPY appends otherwise).
for file in /raw_data/*.csv; do
  table_name=$(basename "$file" .csv)
  echo "Loading data from $file into table $table_name..."
  psql -h db -U admin -d postgres -v ON_ERROR_STOP=1 -c "TRUNCATE TABLE $table_name;"
  psql -h db -U admin -d postgres -v ON_ERROR_STOP=1 -c "\COPY $table_name FROM '$file' DELIMITER ',' CSV HEADER;"
done

echo "Data loading completed."
