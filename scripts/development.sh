#!/bin/sh

set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$(dirname "$CURRENT_DIR")"

docker compose up --build
