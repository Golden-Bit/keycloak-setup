# Keycloak setup su Ubuntu con Docker Compose, Nginx e systemd

Repository operativo per installare, aggiornare e gestire un'istanza self-hosted di Keycloak su Ubuntu con:

- Docker Compose per Keycloak e PostgreSQL
- Nginx come reverse proxy su 80/443
- systemd per l'avvio automatico dello stack
- script per sync del repository, update, backup, restore, healthcheck e logs
- build locale dell'immagine Keycloak a partire dal repository
- directory dedicata alle personalizzazioni UI incluse nella build

> I segreti non vanno versionati. Usa sempre un file `.env` locale, con permessi restrittivi, o un secret manager.

## Panoramica operativa

Il flusso previsto da questo repository è il seguente:

1. si lavora su una copia locale del repository;
2. si sincronizza il contenuto verso la directory di deploy sul server;
3. da quella directory si eseguono build, update e gestione dello stack;
4. i dati applicativi restano persistiti nei volumi Docker e nel database PostgreSQL.

Questo significa che:

- aggiornare il repository **non** equivale a cancellare realm, client, utenti o configurazioni;
- i dati persistenti vengono mantenuti finché non si rimuovono esplicitamente i volumi o il database;
- le modifiche applicative e di interfaccia entrano in produzione tramite rebuild del servizio Keycloak.

## Struttura del repository

```text
keyklock-setup/
├─ docker-compose.yml
├─ Dockerfile
├─ .env.example
├─ README.md
├─ nginx/
│  └─ keycloak.conf
├─ systemd/
│  └─ keycloak-compose.service
├─ scripts/
│  ├─ backup_db.sh
│  ├─ restore_db.sh
│  ├─ update.sh
│  ├─ healthcheck.sh
│  ├─ logs.sh
│  └─ sync-keycloak-repo.sh
├─ docs/
│  ├─ DEPLOYMENT.md
│  ├─ REPOSITORY_SYNC.md
│  ├─ CUSTOM_UI.md
│  ├─ BACKUP_RESTORE.md
│  ├─ OPERATIONS.md
│  ├─ SYSTEMD.md
│  ├─ NGINX_TLS.md
│  ├─ SECURITY.md
│  └─ TROUBLESHOOTING.md
└─ backups/
   └─ .gitkeep
```

## Componenti principali

### Docker Compose
Il file `docker-compose.yml` definisce due servizi:

- `postgres`, con volume persistente `postgres_data`
- `keycloak`, costruito localmente tramite `Dockerfile`, con volume `keycloak_data`

Keycloak viene esposto solo su `127.0.0.1:8080`, così da essere raggiungibile esclusivamente tramite Nginx sullo stesso host.

### Dockerfile
Il `Dockerfile` costruisce un'immagine locale di Keycloak:

- parte dall'immagine ufficiale
- copia le risorse di personalizzazione UI presenti nel repository
- esegue il build di Keycloak
- produce un'immagine pronta all'esecuzione

### Script operativi
Gli script in `scripts/` coprono i casi d'uso più frequenti:

- sync del repository verso la directory di deploy
- update controllato dello stack
- backup e restore del database
- healthcheck e raccolta log

### Nginx
La configurazione Nginx inoltra il traffico verso `127.0.0.1:8080` e passa gli header di proxy richiesti da Keycloak.

### systemd
Il service file consente l'avvio automatico dello stack Docker Compose al boot.

> Verifica sempre la `WorkingDirectory` del servizio systemd: deve puntare alla directory reale di deploy sul server.

## Prerequisiti

Prima del deploy assicurati di avere:

- una VM Ubuntu aggiornata
- Docker Engine e Docker Compose plugin installati
- Nginx installato
- DNS del dominio pubblico già configurato
- porte 80 e 443 aperte a livello di firewall/security group

## Configurazione iniziale

1. Copia il template delle variabili:

```bash
cp .env.example .env
chmod 600 .env
```

2. Compila i valori reali in `.env`:

- dominio pubblico
- credenziali admin iniziali
- nome database
- utente e password database
- timezone

3. Controlla che la configurazione Nginx usi il `server_name` corretto.

4. Se usi systemd, controlla che il file service punti alla directory giusta del repository deployato.

## Avvio manuale dello stack

Dalla root del repository di deploy:

```bash
docker compose build keycloak
docker compose up -d
docker compose ps
```

Verifica locale:

```bash
curl -I http://127.0.0.1:8080/
docker compose logs --tail=200 keycloak
```

## Reverse proxy e TLS

Configurazione tipica:

1. installazione di Nginx;
2. attivazione del vhost del repository;
3. test della configurazione;
4. attivazione di TLS con Certbot o certificato aziendale.

Per la procedura completa vedi `docs/NGINX_TLS.md`.

## Flusso consigliato di aggiornamento

Il flusso corretto è:

1. aggiornare la copia sorgente del repository;
2. sincronizzarla verso la directory di deploy;
3. eseguire backup prudenziale;
4. rebuildare l'immagine Keycloak;
5. riavviare lo stack;
6. verificare log e stato dei container.

Per i dettagli vedi:

- `docs/REPOSITORY_SYNC.md`
- `docs/DEPLOYMENT.md`
- `docs/OPERATIONS.md`

## Persistenza dei dati

I dati di Keycloak non vivono nel repository, ma in:

- PostgreSQL (`postgres_data`)
- dati runtime di Keycloak (`keycloak_data`)

Per questo motivo:

- aggiornare o risincronizzare il repository **non** cancella realm o utenti;
- ricreare il container Keycloak **non** azzera il database;
- comandi distruttivi sui volumi invece possono causare perdita dati.

Non usare in modo leggero:

```bash
docker compose down -v
docker volume prune
docker system prune --volumes
```

## Personalizzazioni UI

Il repository include una directory dedicata alle personalizzazioni dell'interfaccia, che viene incorporata nella build locale di Keycloak.

Queste personalizzazioni si gestiscono a livello di repository e non tramite modifiche manuali dentro il container in produzione.

Per linee guida, rollout, cache e troubleshooting vedi `docs/CUSTOM_UI.md`.

## Backup e restore

Per la gestione del database usa:

```bash
./scripts/backup_db.sh
./scripts/restore_db.sh <dump.sql>
```

Approfondimenti in `docs/BACKUP_RESTORE.md`.

## Operatività quotidiana

Comandi utili:

```bash
./scripts/healthcheck.sh
./scripts/logs.sh
./scripts/update.sh
```

Approfondimenti in `docs/OPERATIONS.md`.

## Troubleshooting e sicurezza

Guide rapide:

- sicurezza: `docs/SECURITY.md`
- problemi operativi: `docs/TROUBLESHOOTING.md`
- systemd: `docs/SYSTEMD.md`

## Percorso di lettura consigliato

Per chi prende in mano il repository da zero, l'ordine consigliato è:

1. `README.md`
2. `docs/DEPLOYMENT.md`
3. `docs/REPOSITORY_SYNC.md`
4. `docs/NGINX_TLS.md`
5. `docs/OPERATIONS.md`
6. `docs/BACKUP_RESTORE.md`
7. `docs/SECURITY.md`
8. `docs/TROUBLESHOOTING.md`
