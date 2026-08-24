terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"     # 3.x de Telmate solo son release-candidates (pre-release)
    }
  }
}
