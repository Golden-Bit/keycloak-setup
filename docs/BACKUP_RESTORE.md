# BACKUP / RESTORE

## Obiettivo
Gestire backup e restore del database PostgreSQL usato da Keycloak.

---

## Perché è importante
Realm, client, utenti e configurazioni stanno nel database PostgreSQL persistito tramite volume Docker.

Prima di:
- aggiornare Keycloak
- cambiare il tema in modo importante
- modificare docker-compose
- fare restore o migrazioni

eseguire sempre un backup.

---

## Backup

### Script repository

```bash
cd /opt/keycloak
./scripts/backup_db.sh
```

### Verifica file creati

```bash
ls -lh backups/
```

---

## Restore

### Script repository

```bash
cd /opt/keycloak
./scripts/restore_db.sh backups/<file>.sql
```

---

## Raccomandazioni

- provare prima il restore su staging
- non fare restore in produzione senza finestra di manutenzione
- conservare più snapshot
- validare il backup periodicamente

---

## Cose da evitare

- restore “alla cieca” senza confermare il file
- restore senza backup corrente prima dell'operazione
- comandi distruttivi sui volumi Docker
