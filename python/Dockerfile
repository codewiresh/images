FROM ghcr.io/codewiresh/workspace-base:latest
USER root
RUN apt-get update && apt-get install -y python3-full python3-venv pipx && \
    rm -rf /var/lib/apt/lists/*
USER codewire
RUN pipx install poetry && pipx install uv
ENV PATH="/home/codewire/.local/bin:${PATH}"
