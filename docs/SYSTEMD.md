# SYSTEMD

## Obiettivo
Gestire l'avvio automatico dello stack Docker Compose con systemd.

---

## File servizio

Percorso nel repository:

```text
systemd/keycloak-compose.service
```

Percorso installato nel sistema:

```text
/etc/systemd/system/keycloak-compose.service
```

---

## Installazione / aggiornamento

```bash
sudo cp systemd/keycloak-compose.service /etc/systemd/system/keycloak-compose.service
sudo systemctl daemon-reload
sudo systemctl enable --now keycloak-compose
```

---

## Verifica stato

```bash
sudo systemctl status keycloak-compose --no-pager -l
```

## Log servizio

```bash
sudo journalctl -u keycloak-compose.service -n 200 --no-pager
sudo journalctl -u keycloak-compose.service -f
```

---

## Verifica file effettivo

```bash
sudo systemctl cat keycloak-compose.service
```

---

## Nota importante

Il servizio deve usare come working directory:

```text
/opt/keycloak
```

non la cartella sorgente `/home/ubuntu/keyklock-setup`.
