FROM ghcr.io/codewiresh/workspace-base:latest
USER root
RUN curl -fsSL https://go.dev/dl/go1.24.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:/home/codewire/go/bin:${PATH}"
ENV GOPATH="/home/codewire/go"
USER codewire
RUN go install golang.org/x/tools/gopls@latest
