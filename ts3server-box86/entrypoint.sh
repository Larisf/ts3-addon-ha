#!/bin/bash
set -e

# Prüfe, ob der Config-Ordner existiert, und erstelle ihn falls nicht
CONFIG_PATH="/config/ts3server"
if [ ! -d "$CONFIG_PATH" ]; then
    echo "📁 Erstelle Config-Ordner unter $CONFIG_PATH"
    mkdir -p "$CONFIG_PATH"
fi

# Kopiere Standardkonfigurationen, falls sie noch nicht existieren
if [ ! -f "$CONFIG_PATH/ts3server.ini" ]; then
    echo "📄 Erstelle Standard-Config (ts3server.ini)"
    cat > "$CONFIG_PATH/ts3server.ini" <<EOL
machine_id=
default_voice_port=9987
voice_ip=0.0.0.0
filetransfer_port=30033
filetransfer_ip=0.0.0.0
query_port=10011
query_ip=0.0.0.0
dbplugin=ts3db_sqlite3
dbsqlpath=/opt/teamspeak/sql/
dbsqlcreatepath=/opt/teamspeak/sql/
EOL
fi
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
