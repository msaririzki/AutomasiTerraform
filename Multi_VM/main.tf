terraform {
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.82.0"
    }
  }
}

locals {
  # Token gabungan: <token_id>=<token_secret>
  proxmox_api_token_combined = "${var.Proxmox_api_token_id}=${var.Proxmox_api_token_secret}"
}

provider "proxmox" {
  endpoint  = var.Proxmox_api_url
  api_token = local.proxmox_api_token_combined
  insecure  = true
}

# Buat 1 VM untuk tiap entri di vm_specs
resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vm_specs

  name        = each.value.vm_name
  node_name   = each.value.node_name
  description = coalesce(try(each.value.description, null), var.default_description)

  # Clone dari template (mis. 9000) yang sudah kamu buat dengan script bash
  clone {
    vm_id     = var.template_id
    node_name = each.value.node_name
    full      = true
  }

  # QEMU Guest Agent host-side
  agent {
    enabled = true
    type    = "virtio"
  }

  # Penting untuk image Ubuntu/Debian (stabil saat resize disk)
  serial_device {
    device = "socket"
  }

  # CPU & Memory
  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = "qemu64"
  }

  memory {
    dedicated = each.value.memory_ded
    floating  = each.value.memory_float
  }

  # Disk utama
  disk {
    datastore_id = each.value.datastore_id # storage untuk DISK (contoh: "SSD1TB")
    interface    = "scsi0"
    size         = each.value.disk_size # HARUS >= ukuran disk di template
    discard      = "on"
    iothread     = true
    ssd          = true
  }

  # NIC (opsional VLAN)
  network_device {
    bridge  = each.value.bridge
    model   = "virtio"
    vlan_id = try(each.value.vlan_id, 0) # 0 = no VLAN tag
  }

  # Cloud-Init
  initialization {
    # WAJIB di-set agar tidak default ke 'local-lvm'
    datastore_id = coalesce(try(each.value.ci_datastore_id, null), var.ci_datastore_id)

    dns {
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway
      }
    }

    user_account {
      username = var.ci_user
      password = var.ci_password
      keys     = [file(var.ci_ssh_public_key)]
    }

    # Kalau mau pakai file Cloud-Init penuh (user_data_file_id / network_data_file_id),
    # taruh di sini — tetapi JANGAN digabung dengan ip_config{} (bisa konflik).
  }

  started = true
  on_boot = true

  # Sabuk pengaman opsional:
  # lifecycle {
  #   prevent_destroy = true          # blokir destroy tak sengaja
  #   # ignore_changes = [memory, cpu]  # contoh jika ada yang diubah manual & ingin diabaikan
  # }
}
