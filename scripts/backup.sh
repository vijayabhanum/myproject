#!/bin/bash

set -e

BACKUP_DIR="/home/deployuser/myproject/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DATE}.sql"

echo "======================="
echo "starting database backup"
echo "======================"

mkdir -p $BACKUP_DIR

echo "Creating backup: $BACKUP_DIR"
docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U produser myproject_prod_db > "${BACKUP_DIR}/${BACKUP_FILE}"

echo "Compressing backup...."
gzip "${BACKUP_DIR}/${BACKUP_FILE}"

echo "cleaning old backups.."
cd $BACKUP_DIR
ls -t backup_*.sql.gz | tail -n +8 | xargs -r rm

COMPRESSED_FILE="${BACKUP_FILE}.gz"
SIZE=$(du -h "{BACKUP_DIR}/${COMPRESSED_FILE}" | cut -f1)

echo ""
echo "=============================="
echo "Back up complete!!"
echo "File: ${COMPRESSED_FILE}"
echo "Size: ${SIZE}"
echo "=============================="
