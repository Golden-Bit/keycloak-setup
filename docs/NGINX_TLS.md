# Nginx e TLS

Questa guida descrive come esporre Keycloak tramite Nginx e come abilitare TLS.

## Nginx

Il repository include un vhost base che:

- ascolta sulla porta 80;
- inoltra verso `127.0.0.1:8080`;
- passa gli header necessari a Keycloak.

## Verifica configurazione

Assicurati che il `server_name` corrisponda al dominio reale.

## Installazione tipica

```bash
sudo apt update
sudo apt install -y nginx
sudo cp nginx/keycloak.conf /etc/nginx/sites-available/keycloak
sudo ln -sf /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled/keycloak
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

## TLS con Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d <dominio>
sudo certbot renew --dry-run
```

## Verifiche

Controlla:

- risoluzione DNS corretta;
- porte 80/443 aperte;
- accesso HTTPS funzionante;
- redirect HTTP -> HTTPS se richiesto.

## Relazione con Keycloak

La configurazione proxy deve essere coerente con:

- `KC_HOSTNAME`
- `KC_PROXY=edge`
- `--proxy-headers=xforwarded`
