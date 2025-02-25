FROM arm64v8/debian:bookworm-slim

# Installiere Abhängigkeiten
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    jq \
    tar \
    git \
    cmake \
    build-essential \
    libsdl2-dev \
    libx11-dev && \
    rm -rf /var/lib/apt/lists/*

# Installiere Box64
RUN git clone https://github.com/ptitSeb/box64.git && \
    cd box64 && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf box64
    

# Hole immer die neuste TS3 Server Version
WORKDIR /app
RUN TS3_URL=$(curl -s 'https://www.teamspeak.com/versions/server.json' | jq -r '.linux.x86.mirrors | values[0]') && \
    wget -O ts3server.tar.bz2 "$TS3_URL" && \
    tar xvf ts3server.tar.bz2 --strip-components=1 && \
    rm ts3server.tar.bz2 && \
    touch .ts3server_license_accepted

# Zusätzliche Installationen
RUN apt-get install -y nodejs npm

# Webinterface bauen
COPY webgui /webgui
RUN cd /webgui && \
    npm install && \
    npm run build && \
    mv build /usr/share/nginx/html && \
    rm -rf /webgui

# Nginx für das GUI
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080

# Starte beide Dienste
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
# Startscript kopieren
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Backup-Skript kopieren
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Starte standardmäßig das Start-Skript
ENTRYPOINT ["/entrypoint.sh"]
