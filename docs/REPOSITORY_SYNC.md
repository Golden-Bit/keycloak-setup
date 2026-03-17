# Repository sync

Questa guida descrive come allineare in modo sicuro la copia sorgente del repository con la copia di deploy usata sul server.

## Modello operativo

Il modello supportato è:

- si lavora sulla copia sorgente del repository;
- si sincronizza il contenuto verso la directory di deploy;
- si eseguono build e comandi operativi dalla directory di deploy.

Questo approccio evita modifiche manuali sparse direttamente nella copia usata da Docker Compose.

## Script disponibile

Il repository include uno script di sync:

```bash
./scripts/sync-keycloak-repo.sh
```

Lo script usa `rsync` per copiare l'intero repository, escludendo elementi che non devono essere sovrascritti in produzione.

## Cosa viene escluso

In genere vengono esclusi:

- `.git/`
- `.env`
- directory di backup locali

Questo evita:

- di sovrascrivere segreti del server;
- di copiare metadati Git inutili nella directory di deploy;
- di alterare backup locali.

## Quando usare lo sync

Usa la sync quando hai modificato:

- file di configurazione del repository;
- script operativi;
- documentazione;
- risorse di personalizzazione UI;
- build locale di Keycloak.

## Flusso consigliato

1. aggiorna la copia sorgente;
2. lancia lo script di sync;
3. verifica che i file principali siano presenti nella directory di deploy;
4. esegui backup;
5. rebuilda Keycloak e riavvia lo stack.

## Verifiche utili dopo la sync

```bash
ls -l Dockerfile docker-compose.yml
ls -l scripts/
find docs -maxdepth 2 -type f | sort
```

## Cosa non fa lo sync

La sync del repository:

- non rimuove i volumi Docker;
- non cancella il database;
- non cambia lo stato applicativo di Keycloak finché non esegui un rebuild o `docker compose up`.

## Cosa evitare

Non usare la directory di deploy come luogo principale di modifica manuale se hai già una copia sorgente separata.

Questo riduce il rischio di drift tra:

- contenuto versionato;
- contenuto realmente eseguito dal server.
