# Proxmox API (contoh)
Proxmox_api_url          = ""
Proxmox_api_token_id     = ""
Proxmox_api_token_secret = "9"

# Cloud-Init user
ci_user     = "root"
ci_password = "Ndekutaok987.."
# INGAT: path dibaca dari mesin yang MENJALANKAN Terraform (Windows/PowerShell kamu)
ci_ssh_public_key = "C:/Users/msari/.ssh/proxmox/id_ed25519_proxmox_lab.pub"

# Template & DNS
template_id = 9000
dns_servers = ["1.1.1.1", "8.8.8.8"]

# VM spec
vm_name      = "ServerRiki"
node_name    = "saririzki"
ip_address   = "192.168.1.19/24"
gateway      = "192.168.1.1"
cores        = 6
memory_ded   = 6144
memory_float = 512
datastore_id = "SSD1TB" # DISK utama
disk_size    = 250      # GB
bridge       = "vmbr0"
description  = "Ubuntu 24.04 via Terraform (root login enabled)"

# Cloud-Init drive storage (biar tidak default ke local-lvm)
ci_datastore_id = "local"
