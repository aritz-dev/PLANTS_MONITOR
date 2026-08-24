# El main raiz NO define recursos: solo LLAMA a los modulos.
# Un LXC por cada entrada de var.lxcs, reutilizando el modulo ./modules/lxc.
module "lxc" {
  source   = "./modules/lxc"
  for_each = var.lxcs

  target_node = each.value.target_node
  hostname    = each.value.hostname
  ip          = each.value.ip
  vmid        = each.value.vmid


  # valores comunes (de variables.tf / terraform.tfvars)
  template = var.lxc_template
  storage  = var.lxc_storage
  memory   = var.lxc_memory
  cores    = var.lxc_cores
  disk     = var.lxc_disk
  gateway  = var.lxc_gateway
  password = var.lxc_password
  ssh_public_keys = var.ssh_public_keys
}
