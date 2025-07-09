#!/bin/bash
# yum install -y python3-pip && pip3 install thehive4py
# exec /init  # <-- Important: this hands control to s6-overlay

set -e

echo "=== Wazuh Custom Startup ==="

# Run initialization script
echo "Running initialization..."
/usr/local/bin/wazuh-init.sh

# Wait a bit for everything to settle
sleep 5

echo "Starting Wazuh Manager..."
# Execute the original Wazuh entrypoint
exec /init
