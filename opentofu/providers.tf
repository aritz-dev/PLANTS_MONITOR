# Conexion a la API de Proxmox (via el port-forward a nodo1:8006).
# Como es un cluster, la API de nodo1 puede crear LXCs en cualquier nodo (target_node).
provider "proxmox" {
  pm_api_url          = var.pve_api_url
  pm_api_token_id     = var.pve_token_id
  pm_api_token_secret = var.pve_token_secret
  pm_tls_insecure     = true          # certificado autofirmado del lab
}
