#!/usr/bin/env bash
set -euo pipefail

LOCAL_REPO="/home/ubuntu/keyklock-setup"
OPT_REPO="/opt/keycloak"

sudo mkdir -p "$OPT_REPO"

sudo rsync -a --delete \
  --exclude '.git/' \
  --exclude '.env' \
  --exclude 'backups/' \
  "$LOCAL_REPO"/ "$OPT_REPO"/

echo "[OK] Sync completato: $LOCAL_REPO -> $OPT_REPO"