#!/bin/sh
set -e

# Register the runtime UID in /etc/passwd before starting opencode.
# getpwuid(3) must resolve the runtime UID; append directly
# since the runtime UID may differ from any pre-registered user.
if ! grep -q "^[^:]*:[^:]*:$(id -u):" /etc/passwd; then
    printf 'opencodeuser:x:%d:%d:opencodeuser:%s:/bin/sh\n' \
        "$(id -u)" "$(id -g)" "${HOME}" >> /etc/passwd
fi

# Pass through to a shell when invoked via `opencode:shell`; otherwise run opencode.
case "${1:-}" in
    bash|sh) exec "$@" ;;
    *) exec opencode "$@" ;;
esac
