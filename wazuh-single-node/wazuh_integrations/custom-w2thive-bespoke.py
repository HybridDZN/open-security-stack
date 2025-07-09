#!/var/ossec/framework/python/bin/python3
import sys
import subprocess
import importlib
import os

# Required modules for TheHive integration
REQUIRED_MODULES = [
    'requests',
    'thehive4py',
    'urllib3'
]

debug_enabled = True

def install_module(module_name):
    """Install a Python module using pip"""
    try:
        subprocess.check_call([
            sys.executable, '-m', 'pip', 'install', '--no-cache-dir', module_name
        ])
        return True
    except subprocess.CalledProcessError as e:
        print(f"Failed to install {module_name}: {e}")
        return False

def check_and_install_dependencies():
    """Check if required modules are installed, install if missing"""
    missing_modules = []
    
    for module in REQUIRED_MODULES:
        try:
            importlib.import_module(module)
            print(f"Module {module}: OK")
        except ImportError:
            print(f"Module {module}: MISSING")
            missing_modules.append(module)
    
    if missing_modules:
        print(f"Installing missing modules: {missing_modules}")
        for module in missing_modules:
            if not install_module(module):
                print(f"Critical: Failed to install {module}")
                sys.exit(1)
        print("All modules installed successfully")
    else:
        print("All required modules are available")

def main():
    """Main integration logic"""
    # Check dependencies first
    check_and_install_dependencies()
    
    # Now import the required modules
    try:
        import requests
        from thehive4py.api import TheHiveApi
        from thehive4py.models import Alert, AlertArtifact
    except ImportError as e:
        print(f"Import error after installation: {e}")
        sys.exit(1)
    
    # Your existing integration logic here
    print("Starting Wazuh-TheHive integration...")
    
    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage: custom-w2thive <alert_json>")
        sys.exit(1)
    
    alert_json = sys.argv[1]
    
    # Process the alert and send to TheHive
    try:
        # Your TheHive integration logic here
        pass
    except Exception as e:
        print(f"Integration error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
