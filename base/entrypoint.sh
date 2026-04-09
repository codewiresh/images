#!/bin/bash
set -e

# Write authorized keys if provided (platform/k8s path).
# Written to /etc/codewire/ssh/ which is always writable,
# even when ~/.ssh is mounted read-only from the host.
if [ -n "$CODEWIRE_SSH_AUTHORIZED_KEYS" ]; then
    echo "$CODEWIRE_SSH_AUTHORIZED_KEYS" > /etc/codewire/ssh/authorized_keys
    chmod 600 /etc/codewire/ssh/authorized_keys
fi

# Generate host key if missing.
if [ ! -f /etc/codewire/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f /etc/codewire/ssh/ssh_host_ed25519_key -N "" -q
fi

# Start sshd on port 2222 as codewire user (no root needed)
/usr/sbin/sshd -f /etc/ssh/sshd_config -e 2>/dev/null &

# Start the local Codewire node automatically when cw is present.
if command -v cw >/dev/null 2>&1 && [ "${CODEWIRE_DISABLE_NODE:-0}" != "1" ]; then
    cw node >/tmp/codewire-node.log 2>&1 &
fi

# Exec the original command
exec "$@"
