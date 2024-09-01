#!/bin/bash

# Update the package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y wget tar

# Create a directory for Node Exporter
sudo mkdir -p /opt/node_exporter

# Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-arm64.tar.gz -P /tmp

# Extract the downloaded tar file
sudo tar -xvzf /tmp/node_exporter-1.8.2.linux-arm64.tar.gz  -C /opt/node_exporter --strip-components=1

# Remove the tar file
rm /tmp/node_exporter-1.8.2.linux-arm64.tar.gz

# Create a systemd service file for Node Exporter
sudo cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/opt/node_exporter/node_exporter
Restart=always

[Install]
WantedBy=default.target
EOF

# Reload systemd and enable Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Print the status of the Node Exporter service
sudo systemctl status node_exporter

echo "Node Exporter installation is complete and running on port 9100."