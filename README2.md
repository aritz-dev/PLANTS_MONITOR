# Ansible — Smart Garden (nodos Proxmox)

Automatización de los 3 nodos Proxmox desde WSL, vía port-forward de VirtualBox.
192.168.1.141
---

## Requisitos previos

1. **Port-forward SSH** en VirtualBox (NAT network):
   - `2211 -> 10.0.10.11:22` (nodo1)
   - `2212 -> 10.0.10.12:22` (nodo2)
   - `2213 -> 10.0.10.13:22` (nodo3)
2. **Clave SSH** copiada a cada nodo (mejor que password):
   ```bash
   ssh-keygen -t ed25519            # si no tienes clave
   ssh-copy-id -p 2211 root@192.168.1.141
   ssh-copy-id -p 2212 root@192.168.1.141
   ssh-copy-id -p 2213 root@192.168.1.141
   ```

   Eso copia tu clave pública al authorized_keys de root en el nodo. A partir de ahí, Ansible entra solo.

   Now try logging into the machine, with:   "ssh -p 2212 'root@192.168.1.141'"
---

## Uso

```bash
# Prueba de conectividad (la "primera tarea")
ansible-playbook site.yml

# O directo, sin playbook:
ansible proxmox_nodes -m ping

# Ejecutar solo en un nodo:
ansible-playbook playbooks/00_connectivity.yml --limit nodo1
```
---

## Estructura y contenido

Explicación de qué es cada carpeta y fichero, y por qué está así (buenas prácticas de Ansible):

```
ansible/
├── ansible.cfg
├── site.yml
├── .gitignore
├── README.md
├── inventory/
│   └── hosts.yml
├── group_vars/
│   └── proxmox_nodes.yml
├── host_vars/
├── playbooks/
│   └── 00_connectivity.yml
└── roles/
    └── common/
        ├── tasks/main.yml
        ├── handlers/main.yml
        ├── defaults/main.yml
        ├── vars/main.yml
        ├── templates/
        ├── files/
        └── meta/main.yml
```
https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html#default-roles-path
### Ficheros raíz

- **`ansible.cfg`** — Configuración de Ansible para este proyecto. Le dice dónde está
  el inventario, el usuario remoto (`root`), desactiva la comprobación de clave de host
  (cómodo en un lab), y activa optimizaciones de SSH (`pipelining`, `ControlPersist`)
  para que las ejecuciones vayan más rápidas. Al existir este fichero en la carpeta,
  no hace falta pasar `-i inventario` en cada comando.

- **`site.yml`** — **Playbook maestro**. Es el "índice" que importa el resto de playbooks
  en orden. Ejecutas solo este y corre todo. Para crecer, basta con descomentar/añadir
  líneas `import_playbook`. Hoy solo llama a `00_connectivity.yml`.

- **`.gitignore`** — Ignora ficheros temporales (`*.retry`, logs, cachés) para no
  ensuciar el repositorio git.

### `inventory/` — QUIÉN

- **`hosts.yml`** — El **inventario**: la lista de máquinas a gestionar y cómo llegar a
  ellas. Aquí están los 3 nodos agrupados en `proxmox_nodes`, cada uno con su
  `ansible_host` (127.0.0.1), su `ansible_port` (2211/2212/2213, el port-forward) y su
  `node_ip` (la IP real 10.0.10.1X). **Nunca** se ponen IPs sueltas en los playbooks:
  todo el "quién" vive aquí.
  variables que empiezan con ansoble son de ansoble, node_ip es inventado.

### `group_vars/` y `host_vars/` — VARIABLES (el CÓMO/CON QUÉ)

- **`group_vars/proxmox_nodes.yml`** — Variables **comunes a todo el grupo** de nodos:
  el usuario, el intérprete de Python, y datos del cluster (`cluster_name`, red, gateway).
  Se aplican a los 3 nodos sin repetir.
- **`host_vars/`** — (vacío por ahora) Aquí irían variables **específicas de un nodo**
  concreto, si alguno necesita algo distinto. Ansible las carga automáticamente por
  nombre de host (`host_vars/nodo1.yml`).

### `playbooks/` — QUÉ HACER

- **`00_connectivity.yml`** — La **primera tarea**: comprueba que Ansible llega por SSH a
  los nodos (módulo `ping`, que NO es un ping de red, sino una prueba de conexión SSH +
  Python) y muestra el hostname/IP de cada uno. Los playbooks van **numerados** (`00_`,
  `10_`, `20_`…) para dejar claro el orden y facilitar añadir los siguientes.

### `roles/` — TAREAS REUTILIZABLES

- **`roles/common/`** — Un **rol**: un bloque de tareas empaquetado y reutilizable, con la
  estructura estándar de Ansible. Cuando una tarea se repita en varios sitios, se mete
  aquí en vez de copiar-pegar. Sus subcarpetas:
  - **`tasks/main.yml`** — las tareas del rol (hoy un placeholder).
  - **`handlers/main.yml`** — "manejadores": tareas que se disparan solo cuando algo
    cambia (ej. reiniciar un servicio tras editar su config).
  - **`defaults/main.yml`** — variables por defecto del rol (baja prioridad, fáciles de
    sobreescribir).
  - **`vars/main.yml`** — variables del rol de alta prioridad.
  - **`templates/`** — plantillas Jinja2 (ficheros de config con variables).
  - **`files/`** — ficheros estáticos para copiar tal cual a los nodos.
  - **`meta/main.yml`** — metadatos del rol (nombre, versión mínima, dependencias).

---

## Cómo crecerá el proyecto

A medida que avances, añadirás playbooks numerados y los engancharás en `site.yml`:

- `10_base_setup.yml` — repos no-subscription, paquetes base, hardening, zona horaria.
- `20_cluster.yml` — formar el cluster (`pvecm create` / `pvecm add`).
- `30_lxc.yml` — crear los contenedores base (k3s, etc.).

La idea: **un fichero por bloque de tareas**, variables fuera del código (en `group_vars`/
`host_vars`), y lo repetible en **roles**. Así el proyecto escala sin volverse un caos.
