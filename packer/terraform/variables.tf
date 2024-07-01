variable "proxmox_url" {
  default = "https://192.168.10.20:8006/api2/json"
}

variable "proxmox_username" {
  default = "infra_as_code@pve"
}

variable "proxmox_password" {
  default = "P@ssw0rd"
}

variable "proxmox_node" {
  default = "pve"
}

variable "proxmox_pool" {
  default = "Templates"
}

variable "proxmox_vm_storage" {
  default = "local-zfs"
}

variable "dc_template" {
  default = "WinServer2019-cloudinit"
}

variable "win10_template" {
  default = "Windows10-cloudinit"
}

variable "dc_ip" {
  default = "192.168.10.200"
}

variable "win10_start_ip" {
  default = "192.168.10.210"
}

variable "win10_count" {
  default = 10
}
