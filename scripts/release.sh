#!/bin/sh

set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$(dirname "$CURRENT_DIR")"

docker compose -f docker-compose.release.yml build
docker compose -f docker-compose.release.yml up test --abort-on-container-exit --force-recreate
