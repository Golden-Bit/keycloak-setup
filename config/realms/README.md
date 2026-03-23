# Configurazioni realm e client

Ogni file JSON in questa cartella descrive un realm e l'elenco dei client da applicare.

## Convenzioni

- `realm` contiene la porzione di configurazione del realm da creare o aggiornare.
- `clients` contiene i `ClientRepresentation` OIDC da creare o aggiornare nello stesso realm.
- il bootstrap è idempotente: se il realm o il client esiste già, viene aggiornato; se non esiste, viene creato.
- i valori di `redirectUris`, `webOrigins`, `baseUrl`, `rootUrl` e `secret` presenti nei file attuali sono esempi di sviluppo e vanno sostituiti prima dell'uso reale.

## Schema atteso

```json
{
  "realm": {
    "realm": "REALM-NAME",
    "enabled": true
  },
  "clients": [
    {
      "clientId": "sample-client",
      "protocol": "openid-connect",
      "enabled": true
    }
  ]
}
```

## File presenti

- `realm-a-dev.json`
- `realm-b-dev.json`

Per applicare tutti i file presenti:

```bash
./scripts/bootstrap_realms.sh
```

Per applicarne uno soltanto:

```bash
./scripts/bootstrap_realms.sh config/realms/realm-a-dev.json
```
