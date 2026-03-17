# OPERATIONS

## Obiettivo
Raccogliere i comandi operativi quotidiani più utili.

---

## Stato stack

```bash
cd /opt/keycloak
docker compose ps
```

## Logs Keycloak

```bash
cd /opt/keycloak
docker compose logs --tail=200 keycloak
```

## Logs Postgres

```bash
cd /opt/keycloak
docker compose logs --tail=200 postgres
```

## Logs continui

```bash
cd /opt/keycloak
docker compose logs -f keycloak
```

## Healthcheck

```bash
cd /opt/keycloak
./scripts/healthcheck.sh
```

## Backup

```bash
cd /opt/keycloak
./scripts/backup_db.sh
```

## Update

```bash
cd /opt/keycloak
./scripts/update.sh
```

## Sync repo sorgente -> deploy

```bash
/home/ubuntu/keyklock-setup/scripts/sync-keycloak-repo.sh
```

## Svuotare cache tema

```bash
cd /opt/keycloak
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```
