#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR_DEFAULT="$ROOT_DIR/config/realms"
CONFIG_TARGET="${1:-$CONFIG_DIR_DEFAULT}"
KCADM_CONFIG_PATH="/tmp/kcadm-bootstrap.config"
KEYCLOAK_INTERNAL_URL="${KEYCLOAK_INTERNAL_URL:-http://127.0.0.1:8080}"
WAIT_SECONDS="${KEYCLOAK_BOOTSTRAP_WAIT_SECONDS:-120}"
WAIT_INTERVAL="${KEYCLOAK_BOOTSTRAP_WAIT_INTERVAL:-5}"

log() {
  echo "[INFO] $*"
}

fail() {
  echo "[ERROR] $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Comando richiesto non trovato: $1"
}

load_env_file() {
  local env_file="$ROOT_DIR/.env"

  if [[ -f "$env_file" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "$env_file"
    set +a
  else
    fail "File .env non trovato in $ROOT_DIR. Copia .env.example in .env e valorizzalo prima di procedere."
  fi

  : "${KEYCLOAK_ADMIN:?Variabile KEYCLOAK_ADMIN mancante nel file .env}"
  : "${KEYCLOAK_ADMIN_PASSWORD:?Variabile KEYCLOAK_ADMIN_PASSWORD mancante nel file .env}"
}

compose_exec() {
  docker compose exec -T -e KCADM_CONFIG="$KCADM_CONFIG_PATH" keycloak "$@"
}

kcadm() {
  compose_exec /opt/keycloak/bin/kcadm.sh "$@"
}

container_write_file() {
  local host_file="$1"
  local container_file="$2"
  local container_dir

  container_dir="$(dirname "$container_file")"
  compose_exec sh -lc "mkdir -p \"$container_dir\" && cat > \"$container_file\"" < "$host_file"
}

container_remove_file() {
  local container_file="$1"
  compose_exec sh -lc "rm -f \"$container_file\"" >/dev/null 2>&1 || true
}

check_compose_stack() {
  docker compose ps keycloak >/dev/null 2>&1 || fail "Servizio keycloak non rilevato dallo stack docker compose. Avvia prima i container con docker compose up -d."
}

wait_for_keycloak() {
  local elapsed=0
  log "Attendo Keycloak su $KEYCLOAK_INTERNAL_URL (timeout ${WAIT_SECONDS}s)"

  while (( elapsed < WAIT_SECONDS )); do
    if curl -fsS "$KEYCLOAK_INTERNAL_URL/realms/master/.well-known/openid-configuration" >/dev/null 2>&1; then
      log "Keycloak risponde correttamente."
      return 0
    fi

    sleep "$WAIT_INTERVAL"
    elapsed=$(( elapsed + WAIT_INTERVAL ))
  done

  fail "Keycloak non è diventato disponibile entro ${WAIT_SECONDS}s. Controlla docker compose logs --tail=200 keycloak"
}

auth_admin() {
  log "Autenticazione admin via kcadm"
  kcadm config credentials \
    --server "$KEYCLOAK_INTERNAL_URL" \
    --realm master \
    --user "$KEYCLOAK_ADMIN" \
    --password "$KEYCLOAK_ADMIN_PASSWORD" >/dev/null
}

expand_target_files() {
  if [[ -d "$CONFIG_TARGET" ]]; then
    find "$CONFIG_TARGET" -maxdepth 1 -type f -name '*.json' | sort
  elif [[ -f "$CONFIG_TARGET" ]]; then
    printf '%s\n' "$CONFIG_TARGET"
  else
    fail "Target di configurazione non valido: $CONFIG_TARGET"
  fi
}

split_config() {
  local source_file="$1"
  local out_dir="$2"

  python3 - "$source_file" "$out_dir" <<'PY'
import json
import sys
from pathlib import Path

source = Path(sys.argv[1])
out_dir = Path(sys.argv[2])
out_dir.mkdir(parents=True, exist_ok=True)

with source.open("r", encoding="utf-8") as fh:
    payload = json.load(fh)

if "realm" not in payload or not isinstance(payload["realm"], dict):
    raise SystemExit(f"Config non valida in {source}: chiave 'realm' mancante o non oggetto")

realm = payload["realm"]
realm_name = realm.get("realm")
if not realm_name:
    raise SystemExit(f"Config non valida in {source}: realm.realm mancante")

clients = payload.get("clients", [])
if not isinstance(clients, list):
    raise SystemExit(f"Config non valida in {source}: clients deve essere un array")

seen = set()
for client in clients:
    if not isinstance(client, dict):
        raise SystemExit(f"Config non valida in {source}: ogni client deve essere un oggetto")
    client_id = client.get("clientId")
    if not client_id:
        raise SystemExit(f"Config non valida in {source}: client senza clientId")
    if client_id in seen:
        raise SystemExit(f"Config non valida in {source}: clientId duplicato '{client_id}'")
    seen.add(client_id)

realm_file = out_dir / "realm.json"
realm_file.write_text(json.dumps(realm, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

manifest_file = out_dir / "clients.tsv"
rows = []
for index, client in enumerate(clients, start=1):
    safe = "".join(ch if ch.isalnum() or ch in "-_." else "_" for ch in client["clientId"])
    client_file = out_dir / f"client-{index:02d}-{safe}.json"
    client_file.write_text(json.dumps(client, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    rows.append(f"{client['clientId']}\t{client_file}\n")

manifest_file.write_text("".join(rows), encoding="utf-8")
print(realm_name)
PY
}

realm_exists() {
  local realm_name="$1"
  kcadm get "realms/$realm_name" >/dev/null 2>&1
}

client_internal_id() {
  local realm_name="$1"
  local client_id="$2"

  kcadm get clients -r "$realm_name" -q clientId="$client_id" --fields id,clientId | \
    python3 -c '
import json
import sys

target = sys.argv[1]

try:
    data = json.load(sys.stdin)
except Exception:
    print("")
    sys.exit(0)

for item in data:
    if item.get("clientId") == target:
        print(item.get("id", ""))
        sys.exit(0)

print("")
' "$client_id"
}

apply_realm() {
  local realm_file="$1"
  local realm_name="$2"
  local container_file="/tmp/bootstrap-${realm_name}-realm.json"

  container_write_file "$realm_file" "$container_file"

  if realm_exists "$realm_name"; then
    log "Aggiorno realm $realm_name"
    kcadm update "realms/$realm_name" -f "$container_file" >/dev/null
  else
    log "Creo realm $realm_name"
    kcadm create realms -f "$container_file" >/dev/null
  fi

  container_remove_file "$container_file"
}

apply_client() {
  local realm_name="$1"
  local client_file="$2"

  local client_id
  client_id="$(python3 -c '
import json
import sys
with open(sys.argv[1], "r", encoding="utf-8") as fh:
    data = json.load(fh)
print(data["clientId"])
' "$client_file")"

  local existing_id
  existing_id="$(client_internal_id "$realm_name" "$client_id")"

  local safe_client_id
  safe_client_id="$(printf '%s' "$client_id" | tr -c 'A-Za-z0-9._-' '_')"
  local container_file="/tmp/bootstrap-${realm_name}-${safe_client_id}.json"

  container_write_file "$client_file" "$container_file"

  if [[ -n "$existing_id" ]]; then
    log "Aggiorno client $client_id nel realm $realm_name"
    kcadm update "clients/$existing_id" -r "$realm_name" -f "$container_file" >/dev/null
  else
    log "Creo client $client_id nel realm $realm_name"
    kcadm create clients -r "$realm_name" -f "$container_file" >/dev/null
  fi

  container_remove_file "$container_file"
}

apply_config_file() {
  local config_file="$1"
  local work_dir="$2"
  local realm_name

  log "Processo configurazione $config_file"
  realm_name="$(split_config "$config_file" "$work_dir")"
  apply_realm "$work_dir/realm.json" "$realm_name"

  if [[ -f "$work_dir/clients.tsv" ]]; then
    while IFS=$'\t' read -r client_id client_file; do
      [[ -z "$client_id" ]] && continue
      apply_client "$realm_name" "$client_file"
    done < "$work_dir/clients.tsv"
  fi
}

main() {
  require_cmd docker
  require_cmd python3
  require_cmd curl

  load_env_file
  check_compose_stack
  wait_for_keycloak
  auth_admin

  local tmp_root
  tmp_root="$(mktemp -d)"
  trap 'rm -rf "$tmp_root"' EXIT

  mapfile -t config_files < <(expand_target_files)
  (( ${#config_files[@]} > 0 )) || fail "Nessun file JSON trovato in $CONFIG_TARGET"

  for config_file in "${config_files[@]}"; do
    local work_dir
    work_dir="$tmp_root/$(basename "$config_file" .json)"
    mkdir -p "$work_dir"
    apply_config_file "$config_file" "$work_dir"
  done

  log "Bootstrap realm/client completato con successo."
}

main "$@"