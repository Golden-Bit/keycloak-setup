# SECURITY

## Hardening minimo consigliato

### Superficie esposta
- esporre pubblicamente solo 80 e 443
- non esporre 8080 e 5432
- mantenere Keycloak bindato su `127.0.0.1:8080`

### Segreti
- non committare `.env`
- usare permessi restrittivi (`chmod 600 .env`)
- ruotare periodicamente password DB e admin

### Reverse proxy / TLS
- forzare HTTPS
- validare correttamente `KC_HOSTNAME`
- verificare gli header forwarded

### Admin console
- limitare accesso amministrativo per IP/VPN
- usare password robuste
- abilitare controlli aggiuntivi dove possibile

### Backup
- backup prima di ogni update importante
- test periodici di restore

### Operazioni distruttive da evitare
Non usare in produzione senza piano esplicito:

```bash
docker compose down -v
docker volume prune
docker system prune --volumes
```
