#!/bin/bash

echo "🚀 Starte TeamSpeak 3 Server..."

CONFIG_PATH="/config/ts3server"
DB_BACKUP_PATH="$CONFIG_PATH/backup"
LOG_PATH="$CONFIG_PATH/logs"

# Prüfe, ob der Config-Ordner existiert, und erstelle ihn falls nicht
if [ ! -d "$CONFIG_PATH" ]; then
    echo "📁 Erstelle Config-Ordner unter $CONFIG_PATH"
    mkdir -p "$CONFIG_PATH"
fi

# Prüfe, ob der Backup-Ordner existiert, und erstelle ihn falls nicht
if [ ! -d "$DB_BACKUP_PATH" ]; then
    echo "🔄 Erstelle Backup-Ordner unter $DB_BACKUP_PATH"
    mkdir -p "$DB_BACKUP_PATH"
fi

# Prüfe, ob der Log-Ordner existiert, und erstelle ihn falls nicht
if [ ! -d "$LOG_PATH" ]; then
    echo "📄 Erstelle Log-Ordner unter $LOG_PATH"
    mkdir -p "$LOG_PATH"
fi

# Falls keine ts3server.ini vorhanden ist, erstelle eine Standardkonfiguration
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
logpath=$LOG_PATH
logappend=1

# Standardmäßig SQLite verwenden, aber MySQL zulassen
dbplugin=ts3db_sqlite3
dbsqlpath=/opt/teamspeak/sql/
dbsqlcreatepath=/opt/teamspeak/sql/

# Falls MySQL gewünscht ist, bitte in config.json aktivieren
EOL
fi

# Falls eine externe MySQL-Datenbank genutzt werden soll, update die ts3server.ini
if [ "$USE_MYSQL" = "true" ]; then
    echo "🛢️ Verwende MySQL-Datenbank anstelle von SQLite"
    sed -i 's/dbplugin=ts3db_sqlite3/dbplugin=ts3db_mysql/' "$CONFIG_PATH/ts3server.ini"
    echo "dbsqlpath=/opt/teamspeak/sql/" >> "$CONFIG_PATH/ts3server.ini"
    echo "dbsqlcreatepath=/opt/teamspeak/sql/" >> "$CONFIG_PATH/ts3server.ini"
    echo "dbpluginparameter=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE" >> "$CONFIG_PATH/ts3server.ini"
fi

# Falls keine Licensekey.dat vorhanden ist, Platzhalter erstellen
if [ ! -f "$CONFIG_PATH/licensekey.dat" ]; then
    echo "🔑 Keine Licensekey.dat gefunden – Platzhalter erstellen"
    touch "$CONFIG_PATH/licensekey.dat"
fi

# Backup-Funktion
backup_database() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    echo "🔄 Erstelle Backup (Timestamp: $TIMESTAMP)"

    # SQLite Backup
    if [ "$USE_MYSQL" != "true" ]; then
        if [ -f "$CONFIG_PATH/ts3server.sqlitedb" ]; then
            echo "💾 Sichere SQLite-Datenbank..."
            cp "$CONFIG_PATH/ts3server.sqlitedb" "$DB_BACKUP_PATH/ts3server_$TIMESTAMP.sqlitedb"
        else
            echo "⚠️ Keine SQLite-Datenbank gefunden, kein Backup notwendig."
        fi
    fi

    # MySQL Backup
    if [ "$USE_MYSQL" = "true" ]; then
        echo "💾 Sichere MySQL-Datenbank..."
        mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "$DB_BACKUP_PATH/ts3server_$TIMESTAMP.sql"
    fi

    echo "✅ Backup abgeschlossen!"
}

# Starte den Backup-Prozess im Hintergrund alle 24 Stunden
while true; do
    backup_database
    sleep 86400
done &

# Starte den TS3-Server mit Box64
echo "🎮 Starte TeamSpeak 3 mit Box64..."
exec box64 ./ts3server_minimal_runscript.sh inifile="$CONFIG_PATH/ts3server.ini"
