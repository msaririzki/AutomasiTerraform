# Proxmox API
variable "Proxmox_api_url" { type = string }
variable "Proxmox_api_token_id" { type = string }
variable "Proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

# Cloud-Init user
variable "ci_user" { type = string }
variable "ci_password" {
  type      = string
  sensitive = true
}
variable "ci_ssh_public_key" { type = string } # path di mesin yang menjalankan Terraform

# Template & DNS
variable "template_id" {
  type    = number
  default = 9000
}
variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}

# Single VM spec
variable "vm_name" { type = string }
variable "node_name" { type = string }
variable "ip_address" { type = string } # contoh: "192.168.1.34/24"
variable "gateway" { type = string }
variable "cores" { type = number }
variable "memory_ded" { type = number }
variable "memory_float" { type = number }
variable "datastore_id" { type = string } # storage untuk DISK utama (contoh: "SSD1TB")
variable "disk_size" { type = number }    # GB
variable "bridge" { type = string }
variable "description" {
  type    = string
  default = "Provisioned by Terraform (bpg/proxmox)"
}

# Cloud-Init drive storage (WAJIB set agar tidak default ke local-lvm)
variable "ci_datastore_id" {
  type    = string
  default = "local" # storage 'local' kamu yang juga punya konten snippets
}
