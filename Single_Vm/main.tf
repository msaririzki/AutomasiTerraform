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
  # bpg token format: <token_id>=<token_secret>
  proxmox_api_token_combined = "${var.Proxmox_api_token_id}=${var.Proxmox_api_token_secret}"
}

provider "proxmox" {
  endpoint  = var.Proxmox_api_url
  api_token = local.proxmox_api_token_combined
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name   = var.node_name
  description = var.description

  # Clone dari template 9000 (Ubuntu 24.04) yang sudah kamu buat dengan skrip bash
  clone {
    vm_id     = var.template_id
    node_name = var.node_name
    full      = true
  }

  # QEMU Guest Agent host-side
  agent {
    enabled = true
    type    = "virtio"
  }

  # Serial console penting untuk image Ubuntu/Debian (aman saat resize disk)
  serial_device {
    device = "socket"
  }

  # CPU & RAM
  cpu {
    cores   = var.cores
    sockets = 1
    type    = "qemu64"
  }

  memory {
    dedicated = var.memory_ded
    floating  = var.memory_float
  }

  # Disk utama (ikut storage kamu)
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
    iothread     = true
    ssd          = true
  }

  # NIC
  network_device {
    bridge = var.bridge
    model  = "virtio"
    # vlan_id = 10  # opsional, kalau butuh VLAN
  }

  # Cloud-Init
  initialization {
    # WAJIB: arahkan Cloud-Init drive ke storage yang ADA (bukan default local-lvm)
    datastore_id = var.ci_datastore_id

    dns {
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      username = var.ci_user
      password = var.ci_password
      keys     = [file(var.ci_ssh_public_key)]
    }

    # Jika nanti mau pakai file snippet Cloud-Init penuh:
    # user_data_file_id    = proxmox_virtual_environment_file.cloudinit_user.id
    # network_data_file_id = proxmox_virtual_environment_file.cloudinit_net.id
    # NOTE: kalau pakai *_file_id, JANGAN gabung dengan ip_config{} (bisa konflik).
  }

  started = true
  on_boot = true
  # bios   = "ovmf"        # biasanya ikut dari template (OVMF/UEFI sudah di template kamu)
  # scsi_hardware = "virtio-scsi-single"  # juga ikut template; boleh set kalau mau eksplisit
}
