# Security

## Superficie esposta

Esponi solo le porte necessarie:

- 80 e 443 verso l'esterno;
- 8080 e 5432 non devono essere pubbliche.

## Segreti

- non versionare `.env`;
- proteggi il file con permessi restrittivi;
- valuta secret manager se l'ambiente lo richiede;
- ruota periodicamente password admin e database.

## Reverse proxy e TLS

- usa HTTPS in produzione;
- verifica header corretti dal proxy;
- valuta HSTS quando l'ambiente è stabile.

## Accesso amministrativo

- limita l'accesso alla console admin;
- applica regole IP, VPN o altri livelli di controllo;
- abilita misure forti di autenticazione dove applicabili.

## Backup e recovery

- esegui backup regolari del database;
- testa periodicamente i restore;
- conserva copie dei backup fuori dal solo host applicativo.

## Aggiornamenti

- evita tag non pinati;
- fai backup prima degli upgrade;
- verifica changelog e compatibilità.
