terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "2.9.11" # or the latest version available
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.pve_node_ip}:8006/api2/json"
  api_token = "${var.tokenid}=${var.tokenkey}"
  insecure  = true
  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_pool" "training_pool" {
  comment = "training resource pool"
  pool_id = "TRAINING"
}

data "proxmox_virtual_environment_vms" "server" {
  tags = ["traininglab-server"]
}

data "proxmox_virtual_environment_vms" "win2019" {
  tags = ["traininglab-win2019"]
}

data "proxmox_virtual_environment_vms" "ws" {
  tags = ["traininglab-ws"]
}

locals {
  vm_id_templates = {
    workstation = data.proxmox_virtual_environment_vms.ws.vms[0].vm_id
    win2019     = data.proxmox_virtual_environment_vms.win2019.vms[0].vm_id
  }

  default_vm_config = {
    memory   = 4096
    cores    = 2
    sockets  = 1
    disk_size = 60
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = {
    DC         = local.vm_id_templates.win2019
    MSSQL      = local.vm_id_templates.win2019
    FS         = local.vm_id_templates.win2019
    WEB        = local.vm_id_templates.win2019
    WS1        = local.vm_id_templates.workstation
    WS2        = local.vm_id_templates.workstation
  }

  name     = each.key
  pool_id  = proxmox_virtual_environment_pool.training_pool.pool_id
  node_name = var.proxmox_node
  on_boot  = false

  clone {
    vm_id  = each.value
    full   = false
    retries = 2
  }

  agent {
    enabled = true
  } 

  memory {
    dedicated = local.default_vm_config.memory
  }

  cpu {
    cores   = local.default_vm_config.cores
    sockets = local.default_vm_config.sockets
  }

  disk {
    interface  = "scsi0"
    file_format = "raw"
    size       = local.default_vm_config.disk_size
    datastore_id = var.storage_name
  }

  network_device {
    bridge = var.netbridge
  }

  lifecycle {
    ignore_changes = [
      disk,
    ]
  }
}

output "ansible_inventory" {
  value = templatefile("${path.module}/inventory_hosts.tmpl", {
    windows_ips = {
      "DC"    = proxmox_virtual_environment_vm.vm["DC"].ipv4_addresses[0][0]
      "MSSQL" = proxmox_virtual_environment_vm.vm["MSSQL"].ipv4_addresses[0][0]
      "FS"    = proxmox_virtual_environment_vm.vm["FS"].ipv4_addresses[0][0]
      "WEB"   = proxmox_virtual_environment_vm.vm["WEB"].ipv4_addresses[0][0]
      "WS1"   = proxmox_virtual_environment_vm.vm["WS1"].ipv4_addresses[0][0]
      "WS2"   = proxmox_virtual_environment_vm.vm["WS2"].ipv4_addresses[0][0]
    }
  })
}
