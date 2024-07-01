terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11" # or the latest version available
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_user         = var.proxmox_username
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "dc" {
  name        = "dc1"
  target_node = var.proxmox_node
  clone       = var.dc_template
  pool        = var.proxmox_pool
  storage     = var.proxmox_vm_storage
  cores       = 2
  sockets     = 1
  memory      = 4096
  disk {
    size = "32G"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
    ip     = var.dc_ip
  }
  cloudinit {
    ipconfig0 = "ip=${var.dc_ip}/24,gw=192.168.10.1"
  }
}