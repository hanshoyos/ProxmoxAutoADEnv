variable "proxmox_url" {
  description = "The Proxmox API URL"
  default     = "https://192.168.10.20:8006/api2/json"
}

variable "proxmox_username" {
  description = "The Proxmox API username"
  default     = "infra_as_code@pve"
}

variable "proxmox_password" {
  description = "The Proxmox API password"
  default     = "P@ssw0rd"
}

variable "proxmox_node" {
  description = "The Proxmox node name"
  default     = "pve"
}

variable "proxmox_pool" {
  description = "The Proxmox pool name"
  default     = "Templates"
}

variable "proxmox_vm_storage" {
  description = "The Proxmox VM storage"
  default     = "local-zfs"
}

variable "dc_template" {
  description = "The Proxmox template for the Domain Controller"
  default     = "WinServer2019-cloudinit"
}

variable "workstation_template" {
  description = "The Proxmox template for the Workstation"
  default     = "Windows10-cloudinit"
}

variable "storage_name" {
  description = "The name of the storage where VMs will be placed"
  default     = "local-lvm"
}

variable "netbridge" {
  description = "The network bridge to which VMs will be connected"
  default     = "vmbr0"
}
