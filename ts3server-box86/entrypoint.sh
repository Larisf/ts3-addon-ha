#!/bin/bash
echo "🔄 Starte TeamSpeak 3 Server (Version: $(cat /app/CHANGELOG | head -n1))"
exec box64 ./ts3server_minimal_runscript.sh
