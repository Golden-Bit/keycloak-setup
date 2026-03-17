# Keycloak Setup (Docker Compose + Nginx + systemd + Custom Themes)

Repository operativo per installare, aggiornare e gestire **Keycloak self-hosted** su **Ubuntu** con:

- **Docker Compose** (`keycloak` + `postgres`)
- **Nginx** reverse proxy su **80/443**
- **systemd** per avvio automatico dello stack
- **build locale** dell'immagine Keycloak con **temi custom** inclusi
- script per **sync repo**, **backup/restore**, **healthcheck**, **logs** e **update**
- struttura separata tra **repo sorgente** e **cartella deploy**

Questo repository è pensato per il flusso operativo attuale:

- **repo sorgente**: `/home/ubuntu/keyklock-setup`
- **repo deployabile**: `/opt/keycloak`
- la cartella in `/opt/keycloak` è quella da cui vengono eseguiti `docker compose` e il servizio `systemd`

> I segreti **non vanno versionati**. Usa `.env` locale nella cartella deploy (`/opt/keycloak/.env`) oppure un secret manager.

---

## Architettura attuale

### Componenti

- **PostgreSQL 16** come database persistente di Keycloak
- **Keycloak 24.0** buildato localmente da `Dockerfile`
- **Nginx** come reverse proxy verso `127.0.0.1:8080`
- **systemd** per avvio automatico del progetto Docker Compose
- **Tema custom** sotto `themes/dens-studio/`

### Persistenza

I dati **non** stanno nel repository ma nei volumi Docker dichiarati in `docker-compose.yml`:

- `postgres_data` → dati PostgreSQL
- `keycloak_data` → dati runtime Keycloak, cache e tmp

Questo significa che puoi aggiornare il repository, ricreare i container e rebuildare l'immagine **senza perdere realm, client, utenti e configurazioni**, purché **non rimuovi i volumi** e **non punti a un altro database**.

> **Non usare** `docker compose down -v` in produzione, perché rimuove i volumi dichiarati nella Compose.

---

## Struttura del repository

```text
keyklock-setup/
├─ Dockerfile
├─ docker-compose.yml
├─ .env.example
├─ README.md
├─ backups/
│  └─ .gitkeep
├─ docs/
│  ├─ BACKUP_RESTORE.md
│  ├─ DEPLOYMENT.md
│  ├─ NGINX_TLS.md
│  ├─ OPERATIONS.md
│  ├─ SECURITY.md
│  ├─ SYSTEMD.md
│  ├─ THEMES.md
│  └─ TROUBLESHOOTING.md
├─ nginx/
│  └─ keycloak.conf
├─ scripts/
│  ├─ backup_db.sh
│  ├─ healthcheck.sh
│  ├─ logs.sh
│  ├─ restore_db.sh
│  ├─ sync-keycloak-repo.sh
│  └─ update.sh
├─ systemd/
│  └─ keycloak-compose.service
└─ themes/
   ├─ dens-studio/
   ├─ dens-studio_prec/
   └─ dens-studio_prec2/
```

---

## File chiave

### `docker-compose.yml`
Definisce:
- `postgres`
- `keycloak`
- i volumi persistenti
- il bind di Keycloak su `127.0.0.1:8080`

### `Dockerfile`
Costruisce localmente l'immagine Keycloak e copia dentro `/opt/keycloak/themes/` tutti i temi presenti nel repository.

### `scripts/sync-keycloak-repo.sh`
Sincronizza il repository sorgente locale verso la cartella deploy in `/opt/keycloak`:

- sorgente: `/home/ubuntu/keyklock-setup`
- destinazione: `/opt/keycloak`

### `scripts/update.sh`
Esegue l'update controllato dello stack:
- `docker compose pull postgres`
- `docker compose build --pull keycloak`
- `docker compose up -d`

### `systemd/keycloak-compose.service`
Gestisce l'avvio automatico dello stack da `/opt/keycloak`.

---

## Prerequisiti server

- Ubuntu Server
- Docker Engine
- Docker Compose plugin
- Nginx
- DNS configurato verso il server
- porte **80** e **443** raggiungibili dall'esterno
- porta **8080 non esposta pubblicamente**

---

## Installazione Docker + Compose (Ubuntu)

Se Docker non è già presente:

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

docker --version
docker compose version
```

Opzionale:

```bash
sudo usermod -aG docker $USER
# logout/login
```

---

## Configurazione iniziale

### 1) Creare `.env`

Nella cartella deploy (`/opt/keycloak`):

```bash
cp .env.example .env
chmod 600 .env
nano .env
```

Valori minimi da impostare:

- `KC_HOSTNAME`
- `KEYCLOAK_ADMIN`
- `KEYCLOAK_ADMIN_PASSWORD`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `TZ`

### 2) Avvio stack

Dalla root del progetto deployato:

```bash
cd /opt/keycloak
docker compose build keycloak
docker compose up -d
docker compose ps
```

Verifica rapida:

```bash
curl -I http://127.0.0.1:8080/
docker compose logs --tail=200 keycloak
```

---

## Flusso operativo raccomandato

### Modifica file nel repository sorgente

Lavora sempre in:

```text
/home/ubuntu/keyklock-setup
```

### Sincronizza verso la cartella deploy

```bash
/home/ubuntu/keyklock-setup/scripts/sync-keycloak-repo.sh
```

### Applica l'update dal deploy path

```bash
cd /opt/keycloak
./scripts/update.sh
```

Questo è il flusso raccomandato per:
- nuove versioni del tema
- modifiche a `docker-compose.yml`
- modifiche al `Dockerfile`
- aggiornamenti script/documentazione

---

## Avvio automatico con systemd

Installazione del servizio:

```bash
sudo cp systemd/keycloak-compose.service /etc/systemd/system/keycloak-compose.service
sudo systemctl daemon-reload
sudo systemctl enable --now keycloak-compose
sudo systemctl status keycloak-compose --no-pager
```

Il servizio deve eseguire lo stack da `/opt/keycloak`.

Per dettagli: vedi `docs/SYSTEMD.md`.

---

## Reverse proxy Nginx

Installazione vhost:

```bash
sudo cp nginx/keycloak.conf /etc/nginx/sites-available/keycloak
sudo ln -sf /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled/keycloak
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

Per TLS e Certbot: vedi `docs/NGINX_TLS.md`.

---

## Temi custom

I temi si trovano sotto:

```text
themes/
```

Ogni cartella è un tema separato. Il tema attivo oggi è pensato per essere selezionato come:

```text
Realm Settings -> Themes -> Login Theme -> dens-studio
```

Per dettagli su:
- struttura tema
- deploy tema
- sync
- cache temi
- troubleshooting su login/register/reset password

vedi `docs/THEMES.md`.

---

## Backup e restore

### Backup DB

```bash
cd /opt/keycloak
./scripts/backup_db.sh
```

### Restore DB

```bash
cd /opt/keycloak
./scripts/restore_db.sh backups/<nome-file>.sql
```

**Prima di un restore in produzione:**
- fermare i servizi interessati
- verificare il file di backup
- preferire prima un test su staging

Dettagli completi: `docs/BACKUP_RESTORE.md`.

---

## Update sicuro

Per applicare aggiornamenti controllati:

```bash
cd /opt/keycloak
./scripts/update.sh
```

Questo script:
1. mostra lo stato stack
2. fa pull delle immagini remote necessarie
3. rebuilda l'immagine Keycloak locale
4. rialza lo stack

### Prima di un update importante

Esegui sempre:

```bash
cd /opt/keycloak
./scripts/backup_db.sh
```

---

## Logs e healthcheck

### Logs

```bash
cd /opt/keycloak
./scripts/logs.sh
```

### Healthcheck

```bash
cd /opt/keycloak
./scripts/healthcheck.sh
```

Per i casi più frequenti: `docs/TROUBLESHOOTING.md`.

---

## Primo accesso Keycloak

Apri:

```text
https://<KC_HOSTNAME>
```

Login admin con:
- `KEYCLOAK_ADMIN`
- `KEYCLOAK_ADMIN_PASSWORD`

### Checklist post-install consigliata

- cambiare password admin
- configurare SMTP
- creare realm dedicato separato da `master`
- configurare client, redirect URI e ruoli
- verificare login, logout, reset password e registrazione
- abilitare localization se richiesta
- selezionare il login theme corretto

---

## Procedure principali disponibili nei docs

- `docs/DEPLOYMENT.md` → deploy iniziale e update completo
- `docs/THEMES.md` → gestione temi Keycloak custom
- `docs/BACKUP_RESTORE.md` → backup e restore database
- `docs/NGINX_TLS.md` → reverse proxy e TLS
- `docs/SYSTEMD.md` → gestione servizio systemd
- `docs/OPERATIONS.md` → operatività quotidiana
- `docs/SECURITY.md` → hardening minimo
- `docs/TROUBLESHOOTING.md` → errori comuni e diagnosi

---

## Errori da evitare

Non fare queste operazioni senza sapere esattamente l'effetto:

```bash
docker compose down -v
docker volume prune
docker system prune --volumes
```

Perché possono rimuovere volumi e dati runtime persistenti.

Evita anche di:
- lavorare direttamente in `/opt/keycloak` modificando file a mano
- copiare temi nel container con `docker cp` come soluzione permanente
- committare `.env`
- cambiare parametri DB se l'obiettivo è solo aggiornare il tema

---

## Note operative importanti

- il nome della cartella sorgente nel flusso attuale è **`keyklock-setup`**
- la cartella deploy attuale è **`/opt/keycloak`**
- il servizio `systemd` deve puntare alla cartella deploy, non a quella sorgente
- i temi `dens-studio_prec` e `dens-studio_prec2` sono copie precedenti: tienili solo se servono davvero come storico

---

## Licenza

Vedi `LICENSE`.
