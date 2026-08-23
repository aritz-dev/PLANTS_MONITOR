# Ansible — Smart Garden (nodos Proxmox)

Automatización de los 3 nodos Proxmox desde WSL, vía port-forward de VirtualBox.

**Filosofía: TODO va en roles.** Aunque sea un solo comando, se mete en un rol.
Los playbooks son "finos": solo dicen *qué rol ejecutar en qué hosts*. Así todo tiene
la MISMA estructura y no te lías.

---

## Requisitos previos

1. **Port-forward SSH** en VirtualBox: `2211->10.0.10.11:22`, `2212->...12:22`, `2213->...13:22`
2. **Clave SSH**: `ssh-copy-id -p 2211 root@<IP_de_Windows>` (y 2212, 2213)

## Uso
```bash
ansible-playbook site.yml                                    # ejecuta todo
ansible-playbook playbooks/connectivity.yml --limit nodo1   # solo un area / un nodo
```

---

## Estructura

```
ansible/
├── ansible.cfg                 # configuracion de Ansible
├── site.yml                    # MAESTRO: importa un playbook por area
├── inventory/
│   └── hosts.yml               # QUIEN: los nodos, puertos, IPs
├── group_vars/
│   └── proxmox_nodes.yml       # variables comunes al grupo
├── host_vars/                  # variables por nodo (si hiciera falta)
├── playbooks/                  # FINOS: solo mapean hosts -> roles
│   └── connectivity.yml
└── roles/                      # el TRABAJO de verdad, todo aqui
    └── connectivity/
        ├── tasks/main.yml      # las tareas (el ping)
        ├── defaults/main.yml   # variables del rol
        ├── meta/main.yml       # metadatos
        └── README.md           # que hace el rol
```

### Las 3 capas (mismo patron siempre)

1. **`site.yml`** = el indice. Importa un playbook por cada area.
2. **`playbooks/<area>.yml`** = FINO. Solo: `hosts: X` + `roles: [Y]`. Sin logica.
3. **`roles/<nombre>/`** = el trabajo real (tareas, variables, plantillas...).

Regla: **la logica SIEMPRE va en un rol**; el playbook solo lo invoca.

---

## Como anadir una tarea nueva (la receta)

Ejemplo: quieres un rol `base` (instalar paquetes, repos...).

1. **Crea el rol**: `mkdir -p roles/base/{tasks,defaults,meta}`
2. **Escribe las tareas** en `roles/base/tasks/main.yml`.
3. **Crea el playbook fino** `playbooks/base.yml`:
   ```yaml
   ---
   - name: Configuracion base de los nodos
     hosts: proxmox_nodes
     roles:
       - base
   ```
4. **Engancha en `site.yml`**: añade `- import_playbook: playbooks/base.yml`.

Cada rol tiene SIEMPRE: `tasks/main.yml` + `defaults/main.yml` + `meta/main.yml` + `README.md`.
(Anade `templates/`, `handlers/`, `files/`, `vars/` SOLO cuando ese rol los necesite — nunca vacios.)

## Roles previstos
- `connectivity`  -> comprobar SSH (HECHO)
- `base`          -> repos no-subscription, paquetes, zona horaria, hardening
- `cluster`       -> formar el cluster (pvecm create/add)
- `k3s`           -> instalar y configurar k3s en los LXC
