# TROUBLESHOOTING

## 1) Keycloak non risponde su 127.0.0.1:8080

```bash
cd /opt/keycloak
docker compose ps
docker compose logs --tail=200 keycloak
docker compose logs --tail=200 postgres
```

Verificare che:
- Postgres sia healthy
- Keycloak non sia in crash loop
- `.env` sia coerente

---

## 2) Realm, client o utenti sembrano spariti
Controllare subito:
- non sia stato cambiato il DB target
- non siano stati rimossi i volumi
- non sia stato eseguito `docker compose down -v`

Verifica:

```bash
cd /opt/keycloak
docker volume ls
```

---

## 3) Tema modificato ma UI invariata

```bash
cd /opt/keycloak
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```

Poi verificare:
- hard refresh browser
- tema corretto selezionato nel realm
- sync repo effettuato
- rebuild eseguito

---

## 4) Login page in errore 500
Controllare i log Keycloak:

```bash
cd /opt/keycloak
docker compose logs --tail=200 keycloak
```

Cause tipiche:
- errore FreeMarker (`.ftl`)
- proprietà mancanti in `theme.properties`
- reference nulle nei template

---

## 5) Nginx / HTTPS non funziona

```bash
sudo nginx -t
sudo systemctl status nginx --no-pager
sudo journalctl -u nginx -n 200 --no-pager
```

Verificare:
- DNS
- porte 80/443
- certificato
- vhost corretto

---

## 6) Service systemd non parte

```bash
sudo systemctl status keycloak-compose --no-pager -l
sudo journalctl -u keycloak-compose.service -n 200 --no-pager
sudo systemctl cat keycloak-compose.service
```

---

## 7) Comandi rapidi

```bash
cd /opt/keycloak
./scripts/logs.sh
./scripts/healthcheck.sh
./scripts/backup_db.sh
./scripts/update.sh
```
