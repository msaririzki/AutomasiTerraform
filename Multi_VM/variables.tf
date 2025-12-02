# === Proxmox API ===
variable "Proxmox_api_url" { type = string }
variable "Proxmox_api_token_id" { type = string }
variable "Proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

# === Cloud-Init user (global) ===
variable "ci_user" { type = string }
variable "ci_password" {
  type      = string
  sensitive = true
}
variable "ci_ssh_public_key" { type = string } # path di mesin yang menjalankan Terraform

# === Template & DNS (global) ===
variable "template_id" {
  type    = number
  default = 9000
}
variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}
variable "default_description" {
  type    = string
  default = "Provisioned by Terraform (bpg/proxmox)"
}

# === Default Cloud-Init drive storage (global) ===
# Bisa di-override per VM via vm_specs[*].ci_datastore_id
variable "ci_datastore_id" {
  type    = string
  default = "local" # arahkan Cloud-Init disk & snippets ke storage 'local' (bukan local-lvm)
}

# === Spesifikasi banyak VM ===
# Bisa override beberapa field per-VM (lihat contoh .tfvars)
variable "vm_specs" {
  type = map(object({
    vm_name         = string
    node_name       = string
    ip_address      = string # "192.168.1.50/24"
    gateway         = string
    cores           = number
    memory_ded      = number
    memory_float    = number
    disk_size       = number # GB, harus >= ukuran template (mis. 25)
    datastore_id    = string # storage untuk DISK utama (mis. "SSD1TB")
    bridge          = string
    vlan_id         = optional(number)
    description     = optional(string)
    ci_datastore_id = optional(string) # storage untuk Cloud-Init (default var.ci_datastore_id)
  }))
}
