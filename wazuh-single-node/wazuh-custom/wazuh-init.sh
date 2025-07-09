#!/bin/bash
# wazuh-init.sh - Initialize Wazuh with custom configurations

set -e

echo "=== Wazuh Initialization Started ==="

# Check if we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Verify Python modules are installed
echo "Verifying Python modules..."
PYTHON_BIN="/var/ossec/framework/python/bin/python3"
REQUIRED_MODULES=("requests" "thehive4py" "urllib3")

for module in "${REQUIRED_MODULES[@]}"; do
    if $PYTHON_BIN -c "import $module" 2>/dev/null; then
        echo "✓ Module $module: Available"
    else
        echo "✗ Module $module: Missing - Installing..."
        $PYTHON_BIN -m pip install --no-cache-dir "$module"
        if $PYTHON_BIN -c "import $module" 2>/dev/null; then
            echo "✓ Module $module: Installed successfully"
        else
            echo "✗ Module $module: Installation failed"
            exit 1
        fi
    fi
done

# Set proper permissions for integrations
echo "Setting integration permissions..."
if [ -d "/var/ossec/integrations" ]; then
    find /var/ossec/integrations -name "custom-w2thive*" -exec chmod +x {} \;
    find /var/ossec/integrations -name "custom-w2thive*" -exec chown root:wazuh {} \;
    echo "✓ Integration permissions set"
else
    echo "⚠ Integrations directory not found"
fi

# Verify integration files exist
echo "Checking integration files..."
if [ -f "/var/ossec/integrations/custom-w2thive" ]; then
    echo "✓ Integration script found"
    # Test the integration script
    if [ -x "/var/ossec/integrations/custom-w2thive" ]; then
        echo "✓ Integration script is executable"
    else
        echo "✗ Integration script is not executable"
        chmod +x "/var/ossec/integrations/custom-w2thive"
        echo "✓ Fixed integration script permissions"
    fi
else
    echo "⚠ Integration script not found at /var/ossec/integrations/custom-w2thive"
fi

if [ -f "/var/ossec/integrations/custom-w2thive.py" ]; then
    echo "✓ Integration Python script found"
else
    echo "⚠ Integration Python script not found at /var/ossec/integrations/custom-w2thive.py"
fi

# Test TheHive connectivity (optional)
echo "Testing TheHive connectivity..."
if command -v curl >/dev/null 2>&1; then
    if curl -s --connect-timeout 5 http://thehive:9000/thehive/api/status >/dev/null 2>&1; then
        echo "✓ TheHive is reachable"
    else
        echo "⚠ TheHive is not reachable (this is normal if TheHive starts after Wazuh)"
    fi
else
    echo "⚠ curl not available, skipping connectivity test"
fi

echo "=== Wazuh Initialization Complete ==="
