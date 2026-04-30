FROM ghcr.io/codewiresh/base:latest
USER root
ARG CODEWIRE_VERSION=latest

# Go
RUN curl -fsSL https://go.dev/dl/go1.24.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:/home/codewire/go/bin:${PATH}"
ENV GOPATH="/home/codewire/go"

# Node
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm yarn && \
    curl -fsSL https://bun.sh/install | bash && mv /root/.bun/bin/bun /usr/local/bin/
RUN npm install -g @openai/codex

# Python
RUN apt-get update && apt-get install -y python3-full python3-venv pipx strace gdb file && \
    rm -rf /var/lib/apt/lists/*

# Build deps for Rust workspaces (pkg-config beyond build-essential,
# protobuf-compiler for crates that build .proto via prost-build).
RUN apt-get update && apt-get install -y pkg-config protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# hcloud CLI (latest stable GitHub release for linux-amd64)
RUN curl -fsSL "$(curl -fsSL https://api.github.com/repos/hetznercloud/cli/releases/latest \
        | grep browser_download_url | grep linux-amd64.tar.gz | cut -d'\"' -f4)" \
        -o /tmp/hcloud.tar.gz && \
    tar -xzf /tmp/hcloud.tar.gz -C /tmp/ hcloud && \
    install -m 0755 /tmp/hcloud /usr/local/bin/hcloud && \
    rm /tmp/hcloud.tar.gz /tmp/hcloud

# Infisical CLI (upstream apt repo)
RUN curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash && \
    apt-get install -y infisical && rm -rf /var/lib/apt/lists/*

RUN install_args="" && \
    if [ "${CODEWIRE_VERSION}" != "latest" ]; then install_args="--version ${CODEWIRE_VERSION}"; fi && \
    curl -fsSL https://raw.githubusercontent.com/codewiresh/codewire/main/install.sh | bash -s -- ${install_args}

USER codewire
RUN curl -fsSL https://claude.ai/install.sh | bash && \
    go install golang.org/x/tools/gopls@latest && \
    pipx install poetry && pipx install uv

# Rust toolchain (stable). Installed as the codewire user so CARGO_HOME
# and RUSTUP_HOME live under $HOME and per-user invariants stay clean.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --default-toolchain stable --no-modify-path

USER root
RUN cp "$(readlink -f /home/codewire/.local/bin/claude)" /usr/local/bin/claude && \
    chmod 0755 /usr/local/bin/claude

USER codewire
ENV PATH="/home/codewire/.cargo/bin:/home/codewire/.local/bin:${PATH}"
