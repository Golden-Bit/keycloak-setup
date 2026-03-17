# THEMES

## Obiettivo
Gestire correttamente i temi custom di Keycloak senza perdere modifiche ai redeploy.

---

## Dove stanno i temi

Nel repository:

```text
themes/
```

Esempio:

```text
themes/dens-studio/login/
```

Ogni cartella sotto `themes/` è un tema distinto.

---

## Come il tema entra in Keycloak

Il `Dockerfile` copia l'intera cartella `themes/` dentro l'immagine Keycloak:

```dockerfile
COPY themes/ /opt/keycloak/themes/
```

Quindi il tema non viene aggiunto a runtime con `docker cp`, ma tramite build locale dell'immagine.

---

## Theme type interessato

Per il progetto attuale si usa soprattutto il **Login Theme**.

Attivazione da Admin Console:

```text
Realm Settings -> Themes -> Login Theme
```

Tema atteso:

```text
dens-studio
```

---

## Flusso corretto per modificare il tema

### 1) Modifica il tema nel repo sorgente

```text
/home/ubuntu/keyklock-setup/themes/dens-studio/
```

### 2) Sincronizza verso `/opt/keycloak`

```bash
/home/ubuntu/keyklock-setup/scripts/sync-keycloak-repo.sh
```

### 3) Rebuild + restart

```bash
cd /opt/keycloak
./scripts/update.sh
```

### 4) Svuota cache tema se necessario

```bash
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```

---

## File principali del tema

```text
themes/dens-studio/login/
├─ theme.properties
├─ template.ftl
├─ login.ftl
├─ register.ftl
├─ login-reset-password.ftl
├─ login-update-password.ftl
├─ info.ftl
├─ messages/
└─ resources/
```

---

## Cosa fa ciascun file

- `theme.properties` → registra CSS, JS, proprietà custom e parent
- `template.ftl` → layout comune della pagina
- `login.ftl` → form login
- `register.ftl` → form registrazione
- `login-reset-password.ftl` → reset password
- `login-update-password.ftl` → cambio password
- `info.ftl` → pagine informative
- `messages/*.properties` → testi localizzati
- `resources/css/styles.css` → look & feel
- `resources/js/app.js` → interazioni JS minime (es. toggle password)

---

## Problemi comuni

### 1) Modifico il tema ma non vedo differenze
- cache tema non svuotata
- browser con asset cached
- realm che usa un altro theme
- file modificati solo in `/home/ubuntu/...` ma non sincronizzati in `/opt/keycloak`

### 2) Background sbagliato
Controllare `styles.css` e i wrapper Keycloak/PatternFly.

### 3) Link register / forgot password non compaiono
Controllare `login.ftl` e le condizioni `realm.registrationAllowed` / `realm.resetPasswordAllowed`.

---

## Regole operative consigliate

- non modificare temi direttamente nel container
- non usare `docker cp` come soluzione definitiva
- lavorare sempre nel repo sorgente
- sincronizzare verso `/opt/keycloak`
- rebuildare il servizio keycloak
