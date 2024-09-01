#!/bin/bash

# Update the package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y wget tar

# Create a directory for mysqld Exporter
sudo mkdir -p /opt/mysqld_exporter

# Download mysqld Exporter
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.1/mysqld_exporter-0.15.1.linux-arm64.tar.gz -P /tmp

# Extract the downloaded tar file
sudo tar -xvzf /tmp/mysqld_exporter-0.15.1.linux-arm64.tar.gz  -C /opt/mysqld_exporter --strip-components=1

# Remove the tar file
rm /tmp/mysqld_exporter-0.15.1.linux-arm64.tar.gz

sudo cat <<EOF | sudo tee /etc/.mysqld_exporter.cnf
    [client]
    user = exporter
    password = exporter_password
EOF
# Create a systemd service file for mysqld Exporter
sudo cat <<EOF | sudo tee /etc/systemd/system/mysqld_exporter.service
[Unit]
Description=Prometheus MySQL Exporter

Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/opt/mysqld_exporter/mysqld_exporter \
  --config.my-cnf=/etc/.mysqld_exporter.cnf \
  --collect.auto_increment.columns \
  --collect.binlog_size \
  --collect.global_status \
  --collect.global_variables \
  --collect.info_schema.clientstats \
  --collect.info_schema.innodb_metrics \
  --collect.info_schema.innodb_tablespaces \
  --collect.info_schema.processlist \
  --collect.info_schema.tablestats \
  --collect.info_schema.tables \
  --collect.info_schema.userstats \
  --collect.perf_schema.eventsstatements \
  --collect.perf_schema.eventswaits \
  --collect.perf_schema.file_events \
  --collect.perf_schema.file_instances \
  --collect.slave_status \
  --collect.info_schema.query_response_time
Restart=always

[Install]
WantedBy=default.target
EOF

# Reload systemd and enable mysqld Exporter service
sudo systemctl daemon-reload
sudo systemctl enable mysqld_exporter
sudo systemctl start mysqld_exporter

# Print the status of the mysqld Exporter service
sudo systemctl status mysqld_exporter

echo "mysqld Exporter installation is complete and running on port 9100."