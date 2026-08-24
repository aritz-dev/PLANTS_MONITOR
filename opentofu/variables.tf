# ---- Conexion a Proxmox (valores en terraform.tfvars, NO se suben a git) ----
variable "pve_api_url" {
  description = "URL de la API de Proxmox, ej: https://192.168.1.141:8010/api2/json"
  type        = string
}
variable "pve_token_id" {
  description = "ID del token, ej: root@pam!opentofu"
  type        = string
}
variable "pve_token_secret" {
  description = "Secreto del token (se muestra UNA vez al crearlo)"
  type        = string
  sensitive   = true
}

# ---- Valores comunes de los LXC ----
variable "lxc_template" {
  description = "Plantilla del LXC (debe estar descargada en cada nodo)"
  type        = string
  default     = "local:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
}
variable "lxc_storage" {
  description = "Almacenamiento del disco raiz del LXC"
  type        = string
  default     = "local-lvm"
}
variable "lxc_memory" {
  description = "RAM de cada LXC en MB"
  type        = number
  default     = 5120        # 5 GB
}
variable "lxc_cores" {
  description = "Nucleos de cada LXC"
  type        = number
  default     = 2
}
variable "lxc_disk" {
  description = "Tamano del disco raiz (GB)"
  type        = number
  default     = 8
}
variable "lxc_gateway" {
  description = "Gateway de la red de los LXC"
  type        = string
  default     = "10.0.10.1"
}
variable "lxc_password" {
  description = "Password de root del LXC"
  type        = string
  sensitive   = true
}

# ---- Un LXC por nodo (cada uno en su target_node) ----
variable "lxcs" {
  description = "Mapa de LXCs a crear: en que nodo, hostname e IP"
  type = map(object({
    target_node = string
    hostname    = string
    ip          = string    # CIDR, ej 10.0.10.21/24
    vmid        = number
  }))
}
variable "ssh_public_keys" {
  type = string
}
