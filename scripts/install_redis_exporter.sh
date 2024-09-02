#!/bin/bash

# Update the package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y wget tar

# Create a directory for redis Exporter
sudo mkdir -p /opt/redis_exporter

# Download redis Exporter
wget https://github.com/oliver006/redis_exporter/releases/download/v1.18.0/redis_exporter-v1.18.0.linux-arm64.tar.gz -P /tmp

# Extract the downloaded tar file
sudo tar -xvzf /tmp/redis_exporter-v1.18.0.linux-arm64.tar.gz  -C /opt/redis_exporter --strip-components=1

# Remove the tar file
rm /tmp/redis_exporter-v1.18.0.linux-arm64.tar.gz

# Create a systemd service file for redis Exporter
sudo cat <<EOF | sudo tee /etc/systemd/system/redis_exporter.service
[Unit]
Description=Prometheus redis Exporter

Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/opt/redis_exporter/redis_exporter -redis.addr redis://localhost:6379
  
Restart=always

[Install]
WantedBy=default.target
EOF

# Reload systemd and enable redis Exporter service
sudo systemctl daemon-reload
sudo systemctl enable redis_exporter
sudo systemctl start redis_exporter

# Print the status of the redis Exporter service
sudo systemctl status redis_exporter

echo "redis Exporter installation is complete and running on port 9104."