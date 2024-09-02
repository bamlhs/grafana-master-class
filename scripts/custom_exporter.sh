#!/bin/bash

DB_USER="exporter"
DB_PASSWORD="exporter_password"
DB_HOST="localhost"
DB_NAME="laravel_db"


RESULT=$(mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -sN -e "SELECT COUNT(*) FROM todos WHERE created_at >= NOW() - INTERVAL 5 MINUTE;")

# Output to a file for Node Exporter
echo "# HELP todos_created_last_5_minutes Number of TODOs created in the last 5 minutes." > /var/lib/node_exporter/textfile_collector/todos_last_5_minutes.prom
echo "# TYPE todos_created_last_5_minutes gauge" >> /var/lib/node_exporter/textfile_collector/todos_last_5_minutes.prom
echo "todos_created_last_5_minutes $RESULT" >> /var/lib/node_exporter/textfile_collector/todos_last_5_minutes.prom