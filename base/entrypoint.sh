#!/bin/bash
set -e

# Write authorized keys if provided
if [ -n "$CODEWIRE_SSH_AUTHORIZED_KEYS" ]; then
    mkdir -p ~/.ssh
    echo "$CODEWIRE_SSH_AUTHORIZED_KEYS" > ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
fi

# Generate host key if missing (runs as codewire, no sudo needed)
if [ ! -f ~/.ssh/ssh_host_ed25519_key ]; then
    mkdir -p ~/.ssh
    ssh-keygen -t ed25519 -f ~/.ssh/ssh_host_ed25519_key -N "" -q
fi

# Start sshd on port 2222 as codewire user (no root needed)
/usr/sbin/sshd -f /etc/ssh/sshd_config -e 2>/dev/null &

# Start the local Codewire node automatically when cw is present.
if command -v cw >/dev/null 2>&1 && [ "${CODEWIRE_DISABLE_NODE:-0}" != "1" ]; then
    cw node >/tmp/codewire-node.log 2>&1 &
fi

# Exec the original command
exec "$@"
