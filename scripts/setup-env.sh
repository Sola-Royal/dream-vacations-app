#!/usr/bin/env bash
set -euo pipefail

command -v docker >/dev/null 2>&1 || { echo "Installing Docker..."; curl -fsSL https://get.docker.com | sh; }
command -v docker-compose >/dev/null 2>&1 || sudo apt-get install -y docker-compose-plugin
command -v node >/dev/null 2>&1 || { curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -; sudo apt-get install -y nodejs; }

echo "Environment ready."
