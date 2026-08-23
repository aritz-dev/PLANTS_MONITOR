# Rol: lxc_template

Descarga la plantilla LXC (Debian por defecto) en el almacenamiento 'local' de CADA nodo.
Se ejecuta en los 3 porque 'local' (/var/lib/vz) es por-nodo, no cluster-wide.

Ajusta el nombre exacto en defaults/main.yml (lxc_template_name) con lo que salga en:
  pveam available --section system | grep debian

Usa 'pveam' (oficial): valida checksum y coloca el fichero en su sitio.
Idempotente: si la plantilla ya esta descargada, no la vuelve a bajar (creates:).
