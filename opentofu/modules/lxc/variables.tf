# Entradas del modulo 'lxc' (lo que el llamante debe pasarle)
variable "target_node" { type = string }
variable "hostname"    { type = string }
variable "ip"          { type = string }   # CIDR, ej 10.0.10.21/24
variable "template"    { type = string }
variable "storage"     { type = string }
variable "memory"      { type = number }
variable "cores"       { type = number }
variable "disk"        { type = number }
variable "gateway"     { type = string }

variable "password" {
  type      = string
  sensitive = true
}
variable "vmid" {
  type    = number
  default = 0        # 0 = autoasignar (por si algún día lo quieres así)
}
variable "ssh_public_keys" {
  type    = string
  default = ""
}