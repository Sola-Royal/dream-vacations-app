#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/var/backups/dream-vacations"
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir -p "$BACKUP_DIR"

docker exec dream-vacations-db pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_DIR/db_$TIMESTAMP.sql.gz"

# Keep only the last 7 backups
find "$BACKUP_DIR" -name "db_*.sql.gz" -type f -printf '%T@ %p\n' \
  | sort -rn | tail -n +8 | cut -d' ' -f2- | xargs -r rm --

echo "Backup complete: db_$TIMESTAMP.sql.gz"
