# Kembalikan daftar VM yang dibuat + VMID-nya
output "vm_ids" {
  value = {
    for k, r in proxmox_virtual_environment_vm.vm :
    k => r.id
  }
}

# Kembalikan mapping nama VM -> IP (sesuai input)
output "vm_ips" {
  value = {
    for k, v in var.vm_specs :
    k => v.ip_address
  }
}
