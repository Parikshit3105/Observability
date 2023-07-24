#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error: $1" >&2
  exit 1
}

# Update the system
#sudo apt-get update
sleep 1

# Create Prometheus user and directories
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Download the latest stable version of Prometheus
latest_version=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
if [ -z "$latest_version" ]; then
  handle_error "Failed to fetch the latest version of Prometheus."
fi

download_url="https://github.com/prometheus/prometheus/releases/download/${latest_version}/prometheus-${latest_version#v}.linux-amd64.tar.gz"
wget "$download_url" || handle_error "Failed to download Prometheus archive."

# Extract Prometheus files
tar xvf "prometheus-${latest_version#v}.linux-amd64.tar.gz"
sudo cp "prometheus-${latest_version#v}.linux-amd64/prometheus" /usr/local/bin/
sudo cp "prometheus-${latest_version#v}.linux-amd64/promtool" /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy configuration files
sudo cp -r "prometheus-${latest_version#v}.linux-amd64/consoles" /etc/prometheus
sudo cp -r "prometheus-${latest_version#v}.linux-amd64/console_libraries" /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Clean up downloaded files
rm -rf "prometheus-${latest_version#v}.linux-amd64.tar.gz" "prometheus-${latest_version#v}.linux-amd64"

# Create Prometheus configuration file
sudo tee /etc/prometheus/prometheus.yml > /dev/null << EOF
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
EOF

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create Prometheus service file
sudo tee /etc/systemd/system/prometheus.service > /dev/null << EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus

echo "Prometheus installation Completed!!!"
