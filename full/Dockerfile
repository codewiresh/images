FROM ghcr.io/codewiresh/workspace-base:latest
USER root
# Go
RUN curl -fsSL https://go.dev/dl/go1.24.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:/home/coder/go/bin:${PATH}"
ENV GOPATH="/home/coder/go"
# Node
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm yarn && \
    curl -fsSL https://bun.sh/install | bash && mv /root/.bun/bin/bun /usr/local/bin/
# Python
RUN apt-get update && apt-get install -y python3-full python3-venv pipx && \
    rm -rf /var/lib/apt/lists/*
USER coder
RUN go install golang.org/x/tools/gopls@latest && \
    pipx install poetry && pipx install uv
ENV PATH="/home/coder/.local/bin:${PATH}"
