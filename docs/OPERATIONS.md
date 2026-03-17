# Operazioni quotidiane

Questa guida raccoglie i comandi più utili per la gestione ordinaria dello stack.

## Stato servizi

```bash
docker compose ps
```

## Log applicativi

Script disponibile:

```bash
./scripts/logs.sh
```

Oppure direttamente:

```bash
docker compose logs --tail=200 keycloak
docker compose logs --tail=200 postgres
```

## Healthcheck

```bash
./scripts/healthcheck.sh
```

## Update controllato

```bash
./scripts/update.sh
```

Lo script:

- mostra lo stato dello stack;
- aggiorna le immagini remote necessarie;
- rebuilda il servizio Keycloak locale;
- rialza lo stack.

## Riavvio manuale

```bash
docker compose restart keycloak
docker compose restart postgres
```

## Rebuild Keycloak

```bash
docker compose build keycloak
docker compose up -d
```

## Cache risorse UI

```bash
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```

## Controlli post-rilascio

Dopo un rilascio verifica:

- `docker compose ps`
- log Keycloak
- log Postgres
- accesso HTTP locale
- accesso pubblico tramite Nginx
