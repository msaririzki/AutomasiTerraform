# Proxmox API
Proxmox_api_url          = "https://100.100.10.1:8006/api2/json"
Proxmox_api_token_id     = "iky..@pam!Terraform"
Proxmox_api_token_secret = "add10101-1069-4ed4-86fd-8a52e85f0319"

# Cloud-Init user (global)
ci_user     = "demo"
ci_password = "Ndekutaok230820.."
# Windows path di mesin yang menjalankan Terraform
ci_ssh_public_key = "C:/Users/msari/.ssh/proxmox/id_ed25519_proxmox_lab.pub"

# Template & DNS
template_id = 9000
dns_servers = ["1.1.1.1", "8.8.8.8"]

# Default Cloud-Init storage (bisa di-override per VM)
ci_datastore_id = "local"

# Banyak VM (contoh 2 VM)
vm_specs = {
  "vm01" = {
    vm_name      = "lab-01"
    node_name    = "saririzki"
    ip_address   = "192.168.1.32/24"
    gateway      = "192.168.1.1"
    cores        = 2
    memory_ded   = 8192
    memory_float = 1024
    disk_size    = 30
    datastore_id = "SSD1TB"
    bridge       = "vmbr0"
    vlan_id      = 0
    # description  = "Ubuntu 24.04 for App A"
    # ci_datastore_id = "local"   # override kalau ingin beda dari default
  }

  "vm02" = {
    vm_name      = "lab-02"
    node_name    = "saririzki"
    ip_address   = "192.168.1.33/24"
    gateway      = "192.168.1.1"
    cores        = 2
    memory_ded   = 16384
    memory_float = 2048
    disk_size    = 40
    datastore_id = "SSD1TB"
    bridge       = "vmbr0"
    vlan_id      = 0 # contoh VLAN
    description  = "Ubuntu 24.04 (VLAN 10)"
    # ci_datastore_id = "local"
  }
}
