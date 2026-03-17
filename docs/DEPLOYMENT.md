# DEPLOYMENT

## Obiettivo
Questa guida descrive il flusso corretto per:
- deploy iniziale
- sincronizzazione repo sorgente -> repo deploy
- rebuild controllato di Keycloak
- rollback operativo minimo

---

## Path attuali

- repo sorgente: `/home/ubuntu/keyklock-setup`
- repo deploy: `/opt/keycloak`

La cartella in `/opt/keycloak` è quella da cui vengono eseguiti:
- `docker compose`
- `systemd`
- backup/restore
- update operativo

---

## Deploy iniziale

### 1) Preparare `.env`

```bash
cd /opt/keycloak
cp .env.example .env
chmod 600 .env
nano .env
```

### 2) Build e startup

```bash
cd /opt/keycloak
docker compose build keycloak
docker compose up -d
docker compose ps
```

### 3) Verifiche iniziali

```bash
curl -I http://127.0.0.1:8080/
docker compose logs --tail=200 keycloak
docker compose logs --tail=200 postgres
```

---

## Flusso aggiornamento standard

### 1) Modifica repo sorgente
Lavora in:

```text
/home/ubuntu/keyklock-setup
```

### 2) Sincronizza verso il deploy path

```bash
/home/ubuntu/keyklock-setup/scripts/sync-keycloak-repo.sh
```

### 3) Backup prudenziale

```bash
cd /opt/keycloak
./scripts/backup_db.sh
```

### 4) Applica update

```bash
cd /opt/keycloak
./scripts/update.sh
```

---

## Rollout manuale equivalente

```bash
cd /opt/keycloak
docker compose pull postgres
docker compose build --pull keycloak
docker compose up -d
```

---

## Cache tema

Se il cambiamento riguarda il tema e non si riflette subito:

```bash
cd /opt/keycloak
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```

---

## Rollback minimo

### Caso A - rollback file repo
Ripristina il repository sorgente a una revisione precedente e sincronizza di nuovo:

```bash
cd /home/ubuntu/keyklock-setup
# git checkout <tag-o-commit>
./scripts/sync-keycloak-repo.sh
cd /opt/keycloak
./scripts/update.sh
```

### Caso B - rollback DB
Solo se strettamente necessario:

```bash
cd /opt/keycloak
./scripts/restore_db.sh backups/<backup>.sql
```

---

## Cose da NON fare

Non usare:

```bash
docker compose down -v
docker volume prune
```

perché possono rimuovere i volumi persistenti.
