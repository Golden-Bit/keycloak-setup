#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f "$ROOT_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
  set +a
fi

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

if [[ "${KEYCLOAK_BOOTSTRAP_APPLY_REALMS:-false}" == "true" ]]; then
  echo "[INFO] Bootstrap realm/client abilitato: avvio scripts/bootstrap_realms.sh"
  "$ROOT_DIR/scripts/bootstrap_realms.sh"
else
  echo "[INFO] Bootstrap realm/client non abilitato. Per attivarlo imposta KEYCLOAK_BOOTSTRAP_APPLY_REALMS=true in .env"
fi
