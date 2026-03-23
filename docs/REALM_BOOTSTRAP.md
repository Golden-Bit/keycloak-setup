# Bootstrap realm e client da file di configurazione

Questa guida descrive il bootstrap automatico di realm e client Keycloak a partire dai file JSON presenti in `config/realms/`.

## Obiettivo

L'obiettivo è rendere ripetibile la creazione e l'aggiornamento di realm e client senza passare dalla console amministrativa.

Lo script incluso nel repository:

- legge uno o più file JSON;
- crea il realm se non esiste;
- aggiorna il realm se esiste già;
- crea i client mancanti;
- aggiorna i client già presenti, mantenendo l'approccio dichiarativo.

## File coinvolti

- `scripts/bootstrap_realms.sh`
- `config/realms/*.json`

## Prerequisiti

Prima di lanciare il bootstrap assicurati che:

- `.env` esista ed esponga `KEYCLOAK_ADMIN` e `KEYCLOAK_ADMIN_PASSWORD`;
- lo stack Docker Compose sia avviato;
- il servizio `keycloak` sia raggiungibile internamente su `http://127.0.0.1:8080`.

## Esecuzione manuale

Applica tutti i realm configurati:

```bash
./scripts/bootstrap_realms.sh
```

Applica un singolo file:

```bash
./scripts/bootstrap_realms.sh config/realms/realm-a-dev.json
```

## Esecuzione automatica dopo l'update

Se vuoi rieseguire il bootstrap ad ogni rilascio, abilita nel file `.env`:

```bash
KEYCLOAK_BOOTSTRAP_APPLY_REALMS=true
KEYCLOAK_BOOTSTRAP_WAIT_SECONDS=120
```

In questo modo `./scripts/update.sh` lancerà automaticamente il bootstrap dopo `docker compose up -d`.

## Note sui client pubblici

I client browser configurati nei file esempio sono predisposti per il flusso OIDC con hosted UI di Keycloak:

- `protocol = openid-connect`
- `standardFlowEnabled = true`
- `publicClient = true`
- `implicitFlowEnabled = false`
- `directAccessGrantsEnabled = false`
- PKCE S256 abilitato tramite attributo `pkce.code.challenge.method`

## Note sui client confidential

I client `confidential-dev` dei due realm sono predisposti per uso server-side:

- `publicClient = false`
- `clientAuthenticatorType = client-secret`
- `serviceAccountsEnabled = true`
- `standardFlowEnabled = true`

I secret presenti nei JSON sono placeholder e vanno sostituiti prima dell'uso effettivo.

## Verifiche post-bootstrap

Controlla:

```bash
docker compose logs --tail=200 keycloak
./scripts/healthcheck.sh
```

Poi verifica da Admin Console:

1. presenza dei realm `REALM-A-DEV` e `REALM-B-DEV`;
2. client associati corretti;
3. login/registration realm-level abilitati;
4. redirect URI e web origins coerenti con i frontend reali.
