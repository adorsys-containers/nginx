#!/bin/bash

set -euo pipefail

if [ -d /docker-entrypoint.d/ ] && [ -n "$(ls -A /docker-entrypoint.d/)" ]; then
  for f in /docker-entrypoint.d/*; do
    # shellcheck source=/dev/null
    . "$f"
  done
fi

exec "$@"
