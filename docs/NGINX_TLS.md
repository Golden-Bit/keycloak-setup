# NGINX / TLS

## Obiettivo
Pubblicare Keycloak in sicurezza tramite Nginx su 80/443 mantenendo Keycloak non esposto pubblicamente su 8080.

---

## Flusso previsto

- Nginx ascolta su 80/443
- proxy verso `127.0.0.1:8080`
- Keycloak resta bindato solo in localhost

---

## Installazione vhost

```bash
sudo cp nginx/keycloak.conf /etc/nginx/sites-available/keycloak
sudo ln -sf /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled/keycloak
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

---

## TLS con Certbot

```bash
sudo apt update
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d <hostname>
sudo certbot renew --dry-run
```

---

## Verifiche

```bash
curl -I http://127.0.0.1:8080/
sudo nginx -t
sudo systemctl status nginx --no-pager
```

---

## Problemi tipici

- DNS errato
- porta 80 chiusa
- server_name non coerente
- header forwarded mancanti
