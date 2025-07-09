#!/usr/bin/env python3

import sys
import json
import requests
from requests.auth import HTTPBasicAuth

# Read configuration parameters
alert_file = open(sys.argv[1])
user = sys.argv[2].split(':')[0]
hook_url = sys.argv[3]

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract issue fields
alert_level = alert_json['rule']['level']
ruleid = alert_json['rule']['id']
description = alert_json['rule']['description']
agentid = alert_json['agent']['id']
agentname = alert_json['agent']['name']
# path = alert_json['syscheck']['path']

# Generate request
headers = {'content-type': 'application/json'}
issue_data = {
    "data": alert_json
}

# Send the request
response = requests.post(hook_url, data=json.dumps(issue_data), headers=headers)

sys.exit(0)
