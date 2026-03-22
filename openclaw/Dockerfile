FROM ghcr.io/codewiresh/base:latest
USER root

# Node 24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# OpenClaw
RUN npm install -g openclaw@latest

USER codewire
EXPOSE 18789
