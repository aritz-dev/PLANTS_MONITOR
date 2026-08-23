# Rol: pve_apitoken

Crea el usuario, rol, ACL y token de API que usa OpenTofu (privilegio minimo, NO root).

Se ejecuta en UN SOLO nodo: la config de Proxmox (usuarios/roles/tokens) es cluster-wide
(/etc/pve replicado), asi que se propaga sola a los 3.

Al crear el token por primera vez, muestra el SECRETO por pantalla -> copialo a
opentofu/terraform.tfvars (pve_token_secret). El secreto solo se ve una vez.

Idempotente: si el rol/usuario/token ya existen, no falla (ignora 'already exists').

ansible-playbook playbooks/pve_apitoken.yml