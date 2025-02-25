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
    libx11-dev \
    && rm -rf /var/lib/apt/lists/*

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
RUN wget -O /tmp/ts3server.tar.bz2 https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2 && \
    tar xvjf /tmp/ts3server.tar.bz2 -C /app/teamspeak3-server --strip-components=1 && \
    rm /tmp/ts3server.tar.bz2 && \
    touch .ts3server_license_accepted

# Startscript kopieren
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Backup-Skript kopieren
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Starte standardmäßig das Start-Skript
ENTRYPOINT ["/entrypoint.sh"]
