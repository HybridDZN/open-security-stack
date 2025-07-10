#!/bin/bash
set -e

cd "$(dirname "$0")"

sudo podman-compose -f wazuh-single-node/docker-compose.yml up -d --force-recreate
sudo podman-compose -f thehive-stack/docker-compose.yml up -d --force-recreate
sudo podman-compose -f misp-docker/docker-compose.yml up -d --force-recreate
