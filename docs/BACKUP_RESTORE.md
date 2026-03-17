# Backup e restore

Questa guida descrive come eseguire backup e restore del database usato da Keycloak.

## Perché il backup è fondamentale

Realm, client, utenti, configurazioni e stato applicativo risiedono nel database PostgreSQL. Il repository e i container non sostituiscono il backup del database.

## Backup

Script disponibile:

```bash
./scripts/backup_db.sh
```

Lo script:

- legge `.env`
- crea la directory `backups/` se non esiste
- esegue un dump PostgreSQL
- salva il file con data nel nome

## Verifica dei backup

Dopo il dump controlla:

```bash
ls -lh backups/
```

Conserva i backup fuori dal solo host applicativo se vuoi una strategia di disaster recovery adeguata.

## Restore

Script disponibile:

```bash
./scripts/restore_db.sh <dump.sql>
```

Lo script:

- controlla la presenza di `.env`
- ferma il container Keycloak
- ripristina il dump nel database
- riavvia Keycloak

## Precauzioni

Prima di un restore:

- fai un backup dello stato corrente;
- prova la procedura in staging quando possibile;
- verifica che il dump sia coerente con l'ambiente target.

## Casi tipici d'uso

Restore utile per:

- rollback dopo aggiornamenti falliti;
- recupero ambiente;
- migrazione controllata;
- verifica di integrità dei backup.
