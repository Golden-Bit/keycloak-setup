# Deployment

Questa guida descrive il deploy standard del repository su un host Ubuntu con Docker Compose, Nginx e systemd.

## Obiettivo

L'obiettivo è ottenere:

- un database PostgreSQL persistente;
- un servizio Keycloak eseguito in container;
- un reverse proxy Nginx su 80/443;
- una procedura di rilascio ripetibile basata sul repository.

## Prerequisiti

Verifica prima di iniziare:

- Docker Engine installato;
- Docker Compose plugin disponibile;
- Nginx installato o installabile;
- DNS del dominio pubblico corretto;
- porte 80/443 aperte;
- repository presente sia come sorgente di lavoro sia come copia deployabile.

## Directory di lavoro e di deploy

Flusso raccomandato:

- copia sorgente: usata per modifiche, versionamento e revisione;
- copia di deploy: usata per `docker compose build`, `up`, `logs`, `backup`, `restore`.

La directory di deploy deve essere coerente con:

- `systemd`
- eventuali script di sync
- comandi operativi lanciati dal team

## Configurazione ambiente

1. Copia `.env.example` in `.env`
2. Imposta i valori reali
3. Proteggi il file con permessi restrittivi

```bash
cp .env.example .env
chmod 600 .env
```

## Build e avvio iniziale

```bash
docker compose build keycloak
docker compose up -d
docker compose ps
```

## Verifiche iniziali

Controlli minimi:

```bash
curl -I http://127.0.0.1:8080/
docker compose logs --tail=200 keycloak
docker compose logs --tail=200 postgres
```

Controlla che:

- Postgres sia healthy;
- Keycloak parta senza errori gravi;
- la porta 8080 sia raggiungibile solo in locale.

## Abilitazione reverse proxy

Dopo l'avvio dei container:

1. installa o verifica Nginx;
2. copia il file vhost;
3. abilita il sito;
4. testa la configurazione;
5. ricarica Nginx.

Per i dettagli vedi `NGINX_TLS.md`.

## TLS

Una volta verificato l'accesso HTTP, abilita TLS con:

- Certbot
- oppure certificato aziendale

## Abilitazione systemd

Il service file permette l'avvio automatico dopo reboot. Prima di abilitarlo controlla:

- `WorkingDirectory`
- percorso reale di `docker compose`
- coerenza con la directory di deploy

Per i dettagli vedi `SYSTEMD.md`.

## Deploy successivi

Per i rilasci successivi:

1. sincronizza il repository verso la directory di deploy;
2. fai un backup del database;
3. rebuilda Keycloak;
4. riavvia lo stack;
5. controlla log e stato.

## Comandi consigliati

```bash
./scripts/backup_db.sh
docker compose build keycloak
docker compose up -d
docker compose logs --tail=200 keycloak
```

## Attenzioni operative

Non usare comandi distruttivi sui volumi durante un normale deploy.

Evita:

```bash
docker compose down -v
docker volume prune
```

Questi comandi possono rimuovere la persistenza del database o dei dati runtime.
