#!/bin/sh
set -e

# Fallback to ./app if env var is not set
AIRBYTE_ENTRYPOINT="${AIRBYTE_ENTRYPOINT:-./app}"

echo "[entrypoint] Using: $AIRBYTE_ENTRYPOINT $@"
exec $AIRBYTE_ENTRYPOINT "$@"
