# systemd

Questa guida descrive come usare il service systemd fornito dal repository.

## Scopo

Il service permette di avviare lo stack Docker Compose al boot del server.

## File incluso

Percorso:

```text
systemd/keycloak-compose.service
```

## Verifica preliminare

Prima di installarlo controlla:

- `WorkingDirectory`
- percorso di `docker compose`
- nome del servizio desiderato

La `WorkingDirectory` deve puntare alla directory reale di deploy usata sul server.

## Installazione

```bash
sudo cp systemd/keycloak-compose.service /etc/systemd/system/keycloak-compose.service
sudo systemctl daemon-reload
sudo systemctl enable --now keycloak-compose.service
```

## Verifica stato

```bash
sudo systemctl status keycloak-compose.service --no-pager -l
```

## Log

```bash
sudo journalctl -u keycloak-compose.service -n 200 --no-pager
sudo journalctl -u keycloak-compose.service -f
```

## Nota importante su ExecStop

Il file attuale usa `docker compose down` come stop. Questo ferma e rimuove i container, ma non i volumi, purché non venga usata l'opzione `-v`.

Se preferisci una semantica più conservativa puoi valutare, in futuro, uno stop basato su `docker compose stop`.
