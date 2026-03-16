#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[INFO] Pre-update: stato stack"
docker compose ps

echo "[INFO] Pull immagini remote necessarie"
docker compose pull postgres

echo "[INFO] Rebuild immagine Keycloak locale con temi"
docker compose build --pull keycloak

echo "[INFO] Apply update (up -d)"
docker compose up -d

echo "[INFO] Post-update: stato stack"
docker compose ps