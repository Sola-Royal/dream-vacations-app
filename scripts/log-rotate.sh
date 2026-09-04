#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/dream-vacations"
find "$LOG_DIR" -name "*.log" -mtime +14 -delete
find "$LOG_DIR" -name "*.log" -size +50M -exec gzip {} \;

echo "Log rotation complete."
