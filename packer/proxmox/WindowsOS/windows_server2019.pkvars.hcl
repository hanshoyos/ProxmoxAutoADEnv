winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "WinServer-2019"
template_description  = "Windows Server 2019 64-bit - build 17763.737.190906-2324 - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/windows_server_2019.iso"
autounattend_iso      = "./iso/Autounattend_winserver2019_cloudinit.iso"
autounattend_checksum = "sha256:4ff4553a88d04eb5fb08ae2c1f4dc14d47374adb9a3c8279be117cc0eb36d1df"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "40G"
vm_sockets            = "1"
os                    = "win10"
vm_disk_format        = "raw"
