output "lxc_resumen" {
  description = "Resumen de los LXC creados (desde el modulo)"
  value = {
    for k, m in module.lxc : k => {
      vmid     = m.vmid
      hostname = m.hostname
      nodo     = m.target_node
    }
  }
}
