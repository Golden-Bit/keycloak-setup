# Personalizzazioni UI

Questa guida descrive come gestire in modo corretto le personalizzazioni dell'interfaccia Keycloak incluse nel repository.

## Principio generale

Le personalizzazioni UI devono essere trattate come codice del repository:

- stanno in una directory dedicata;
- vengono incluse nella build locale di Keycloak;
- non vanno mantenute come modifiche manuali fatte dentro il container in produzione.

## Approccio consigliato

L'approccio consigliato è:

1. modificare le risorse UI nella copia sorgente del repository;
2. sincronizzare il repository verso la directory di deploy;
3. rebuildare il servizio Keycloak;
4. svuotare la cache delle risorse, se necessario;
5. verificare il comportamento dal browser e dai log.

## Tipologie di modifiche tipiche

Le personalizzazioni più comuni riguardano:

- layout e markup delle pagine di autenticazione;
- fogli di stile;
- script client-side;
- immagini e asset statici;
- testi e messaggi localizzati.

## Build locale

Poiché il `Dockerfile` incorpora le risorse UI nella build, le modifiche diventano effettive solo dopo rebuild del servizio Keycloak.

Comando tipico:

```bash
docker compose build keycloak
docker compose up -d
```

## Cache

Dopo un aggiornamento UI può essere necessario svuotare la cache interna delle risorse:

```bash
docker compose exec keycloak rm -rf /opt/keycloak/data/tmp/kc-gzip-cache
docker compose restart keycloak
```

## Verifica

Dopo il rebuild:

- controlla che la pagina carichi senza errori server;
- verifica i log del container;
- fai hard refresh del browser o usa una finestra in incognito.

## Errori tipici

Problemi frequenti:

- markup incompleto o non compatibile con il rendering di Keycloak;
- stili parent non neutralizzati;
- cache browser o cache interna ancora attive;
- percorso asset errato;
- elementi di layout lasciati al rendering standard e non coerenti col resto della UI.

## Buone pratiche

- evita modifiche manuali dentro il container in produzione;
- esegui sempre il rebuild dopo modifiche UI;
- conserva il comportamento coerente tra login, registrazione, reset password e pagine informative;
- verifica sempre i log se appare un errore 500 o un rendering incompleto.
