# Rol: cluster

Forma el cluster Proxmox con `pvecm` (solo comandos, sin modulos de comunidad).

- El nodo `cluster_primary` (group_vars) ejecuta `pvecm create`.
- El resto ejecutan `pvecm add <ip_del_primario>` (de uno en uno, throttle:1).
- Idempotente: si `/etc/pve/corosync.conf` ya existe, no hace nada.

## PRERREQUISITOS
1. **Nodos VACIOS**: los que se unen NO deben tener ningun LXC/VM.
2. **Confianza SSH entre nodos**: la aporta el rol 'ssh_trust' (ejecutalo antes).
3. Los nodos se ven en la red 10.0.10.0/24.

## Uso
```bash
# Todo de golpe (recomendado): confianza SSH + cluster de los 3 nodos
ansible-playbook site.yml

# O solo el cluster (si ssh_trust ya se hizo):
ansible-playbook playbooks/cluster.yml
```
