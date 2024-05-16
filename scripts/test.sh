#!/bin/sh

set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$(dirname "$CURRENT_DIR")"

docker compose -f docker-compose.test.yml up --build --abort-on-container-exit --force-recreate
