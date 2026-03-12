#!/bin/bash
set -e

# Write authorized keys if provided
if [ -n "$CODEWIRE_SSH_AUTHORIZED_KEYS" ]; then
    mkdir -p ~/.ssh
    echo "$CODEWIRE_SSH_AUTHORIZED_KEYS" > ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
fi

# Configure sshd: key auth only
sudo tee /etc/ssh/sshd_config.d/codewire.conf > /dev/null <<'SSHD'
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
SSHD

# Start sshd in background
sudo /usr/sbin/sshd

# Exec the original command
exec "$@"
