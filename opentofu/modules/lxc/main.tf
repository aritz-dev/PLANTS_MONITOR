# Modulo 'lxc': crea UN contenedor LXC en Proxmox.
resource "proxmox_lxc" "this" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = var.template
  password     = var.password
  unprivileged = true
  start        = true
  cores        = var.cores
  memory       = var.memory
  vmid         = var.vmid
  ssh_public_keys = var.ssh_public_keys

  rootfs {
    storage = var.storage
    size    = "${var.disk}G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.ip
    gw     = var.gateway
  }

  features {
    nesting = true   # para correr contenedores/k3s dentro
  }
}
