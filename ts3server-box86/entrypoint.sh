#!/bin/bash
set -e

# Prüfe, ob eine CHANGELOG-Datei vorhanden ist, und lese die Version
if [ -f /app/CHANGELOG ]; then
  VERSION=$(head -n1 /app/CHANGELOG)
else
  VERSION="unbekannt"
fi
echo "Starte TeamSpeak 3 Server (Version: $VERSION)"

# Prüfe, ob eine externe MySQL-Datenbank genutzt werden soll
# Die in config.json definierten Optionen werden als Umgebungsvariablen gesetzt:
if [ "$DB_TYPE" = "mysql" ]; then
  echo "Konfiguriere externe MySQL-Datenbank..."
  # Erstelle eine MySQL-Konfigurationsdatei (Passe den Inhalt ggf. an die Anforderungen von TS3 an)
  cat > /app/ts3db_mysql.ini <<EOF
[config]
host=$MYSQL_HOST
username=$MYSQL_USER
password=$MYSQL_PASSWORD
database=$MYSQL_DATABASE
EOF
else
  echo "Verwende Standard-SQLite-Datenbank."
fi

# Prüfe, ob eine externe TS3 Server Lizenz (LICENSEKEY.dat) vorhanden ist und kopiere sie
if [ -f /config/LICENSEKEY.dat ]; then
  echo "Lade externe TS3 Server Lizenz (LICENSEKEY.dat) aus /config..."
  cp /config/LICENSEKEY.dat /app/LICENSEKEY.dat
fi

# Starte den TS3-Server mittels Box64
exec box64 ./ts3server_minimal_runscript.sh
