# Salidas del modulo (lo que expone hacia fuera)
output "vmid"        { value = proxmox_lxc.this.vmid }
output "hostname"    { value = proxmox_lxc.this.hostname }
output "target_node" { value = proxmox_lxc.this.target_node }
