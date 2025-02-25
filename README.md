# Home Assistant TeamSpeak 3 Add-on mit Auto-Update, Box64, optionaler MySQL-Unterstützung und Datenbank-Backup

📥 **Installation:**
1. In Home Assistant:
   - Gehe zu **Einstellungen → Add-ons → Repositories**
   - Füge die URL hinzu: `https://github.com/Larisf/ha-ts3-addon`
2. Installiere das Add-on "TS3 Server (Box64)"
3. Stelle sicher, dass die Ports 9987/udp, 10011/tcp und 30033/tcp freigegeben sind.
4. Richte unter Umständen auch ein Backup-Verzeichnis ein (Mapping: `/backup`).

🔧 **Bei Updates:**
- Starte das Add-on neu, es lädt automatisch die neueste Version vom offiziellen TS3-Server herunter!

📜 **Lizenz:**
- Dieses Add-on verwendet standardmäßig die automatisch akzeptierte TS3 Server Lizenz.
- Falls du eine kommerzielle TS3 Server Lizenz besitzt, lege deine Lizenz in einer Datei namens `LICENSEKEY.dat` im gemappten `/config`-Ordner ab. Dadurch wird diese beim Add-on-Start verwendet.

💡 **Externe MySQL-Datenbank (optional):**
- Standardmäßig wird SQLite genutzt.
- Um eine externe MySQL-Datenbank zu verwenden, setze in der Add-on-Konfiguration den Parameter `db_type` auf `"mysql"` und fülle die Felder `mysql_host`, `mysql_user`, `mysql_password` und `mysql_database` aus.
- Beim Add-on-Start wird dann automatisch eine MySQL-Konfiguration generiert.

💾 **Datenbank-Backup:**
- Das Add-on enthält ein Backup-Skript (`backup.sh`), das ein Backup der verwendeten Datenbank erstellt:
  - Für MySQL wird mittels `mysqldump` ein Backup im `/backup`-Ordner gespeichert.
  - Für SQLite wird die Datenbankdatei in den `/backup`-Ordner kopiert.
- Um ein Backup manuell zu erstellen, führe im Terminal folgenden Befehl aus:
  ```bash
  docker exec -it addon_ts3server-box64 /backup.sh
