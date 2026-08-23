# Rol: ssh_trust

Crea confianza SSH root<->root entre TODOS los nodos (malla), necesario para que
`pvecm add` pueda hacer SSH de un nodo a otro sin password.

Que hace (todo con modulos builtin):
1. Genera la clave SSH de root en cada nodo (si no existe).
2. Lee la clave publica de cada nodo (slurp).
3. Autoriza la clave de CADA nodo en TODOS (malla todos-en-todos).
4. Configura /root/.ssh/config para no preguntar por host keys entre nodos (10.0.10.*).

Se ejecuta en los 3 nodos. Debe correr ANTES del rol 'cluster'.
