# Rol: connectivity

Comprueba que Ansible llega por SSH a los nodos y muestra su hostname/IP.

- **tasks/main.yml** — el ping (prueba SSH) + un debug.
- **defaults/main.yml** — variables del rol (vacio por ahora).
- **meta/main.yml** — metadatos.

Se invoca desde `playbooks/connectivity.yml`.
