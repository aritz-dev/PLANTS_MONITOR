# OpenTofu — LXCs sobre el cluster Proxmox (con MODULOS)

Crea 1 LXC por nodo (5 GB RAM) via la API de Proxmox, usando un modulo reutilizable.

## Estructura
```
opentofu/
├── versions.tf        # version de OpenTofu y del provider
├── providers.tf       # conexion a la API de Proxmox
├── variables.tf       # variables del NIVEL RAIZ (con defaults)
├── terraform.tfvars   # VALORES (secretos) — lo creas tu, esta en .gitignore
├── main.tf            # NO define recursos: solo LLAMA a los modulos
├── outputs.tf         # expone lo que devuelven los modulos
└── modules/
    └── lxc/           # modulo REUTILIZABLE para crear un LXC
        ├── main.tf        # el recurso proxmox_lxc
        ├── variables.tf   # ENTRADAS del modulo
        └── outputs.tf     # SALIDAS del modulo
```

### La idea de los modulos
- Un **modulo** = una "funcion" reutilizable: recibe variables (entradas), crea recursos,
  y devuelve outputs (salidas). Aisla el "como se crea un LXC" en un sitio.
- El **main raiz** NO tiene recursos: solo hace `module "lxc" { ... }` una vez por cada
  entrada de `var.lxcs` (`for_each`). Si manana quieres 10 LXC, solo cambias `terraform.tfvars`.
- Ventaja: el "como" (dentro del modulo) esta separado del "cuantos/cuales" (en el raiz).

## Sobre un modulo de REDES
Ahora mismo NO hay red que provisionar con OpenTofu:
- El bridge `vmbr0` lo crea Proxmox al instalar.
- La NAT network es de VirtualBox (fuera de Proxmox).
El provider Telmate no gestiona bridges/SDN. Un modulo 'network' quedaria VACIO (paja).
Se anadiria si en el futuro usas SDN o reglas de firewall (con el provider bpg).

## PRERREQUISITOS
1. Token de API creado (rol pve_apitoken en Ansible).
2. Plantilla LXC descargada en los 3 nodos (rol lxc_template en Ansible).
3. `terraform.tfvars` con el token y la password de los LXC.

## Ejecutar
```bash
tofu init      # descarga el provider y prepara los modulos
tofu plan      # muestra que va a crear
tofu apply     # crea los 3 LXC (escribe 'yes')
tofu destroy   # los borra
```
