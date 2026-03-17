# Troubleshooting

## Keycloak non risponde in locale

Controlla:

```bash
docker compose ps
docker compose logs --tail=200 keycloak
docker compose logs --tail=200 postgres
```

## Errore pubblico sul dominio

Verifica:

- DNS
- Nginx
- porte 80/443
- certificati TLS
- header proxy

## Redirect o URL errati

Controlla la coerenza tra:

- `KC_HOSTNAME`
- configurazione Nginx
- `KC_PROXY=edge`
- `--proxy-headers=xforwarded`

## Modifiche UI non visibili

Controlla:

- rebuild del servizio Keycloak;
- sync corretto del repository;
- cache interna risorse svuotata;
- hard refresh del browser;
- log del container.

## Errori 500 sulle pagine di autenticazione

Controlla i log Keycloak subito dopo l'errore:

```bash
docker compose logs --tail=200 keycloak
```

Cerca riferimenti a:

- template non validi;
- variabili mancanti;
- asset non trovati;
- eccezioni FreeMarker.

## Problemi systemd

Controlla:

```bash
sudo systemctl status keycloak-compose.service --no-pager -l
sudo journalctl -u keycloak-compose.service -n 200 --no-pager
```

## Problemi sui volumi o perdita dati

Verifica se sono stati eseguiti comandi distruttivi come:

```bash
docker compose down -v
docker volume prune
```

In caso di dubbio, sospendi altre operazioni e valuta restore da backup.
