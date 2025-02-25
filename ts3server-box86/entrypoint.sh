#!/bin/bash

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

# Falls keine Licensekey.dat vorhanden ist, Platzhalter erstellen
if [ ! -f "$CONFIG_PATH/licensekey.dat" ]; then
    echo "🔑 Keine Licensekey.dat gefunden – Platzhalter erstellen"
    touch "$CONFIG_PATH/licensekey.dat"
fi

# Starte den TS3-Server
exec box64 ./ts3server_minimal_runscript.sh inifile="$CONFIG_PATH/ts3server.ini"


chmod +x entrypoint.sh
