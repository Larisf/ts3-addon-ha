#!/bin/bash
set -e

# Erstelle einen Zeitstempel
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="/backup"

# Stelle sicher, dass das Backup-Verzeichnis existiert
mkdir -p ${BACKUP_DIR}

if [ "$DB_TYPE" = "mysql" ]; then
  echo "Erstelle MySQL-Backup..."
  mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" > ${BACKUP_DIR}/ts3_mysql_backup_${TIMESTAMP}.sql
else
  echo "Erstelle SQLite-Backup..."
  # Annahme: Die SQLite-Datenbank befindet sich in /app/ts3server.sqlite – passe diesen Pfad an, falls erforderlich!
  cp /app/ts3server.sqlite ${BACKUP_DIR}/ts3_sqlite_backup_${TIMESTAMP}.sqlite
fi

echo "Backup erstellt im Ordner ${BACKUP_DIR} (Zeitstempel: ${TIMESTAMP})"
