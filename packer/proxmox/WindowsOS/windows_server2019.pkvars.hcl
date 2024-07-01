winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "WinServer2019-cloudinit"
template_description  = "Windows Server 2019 64-bit - build 17763.737.190906-2324 - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/windows_server_2019.iso"
autounattend_iso      = "./iso/Autounattend_winserver2019_cloudinit.iso"
autounattend_checksum = "sha256:5456a8b0b1d1506ed10ca40cd57a4924fb05c8344aa548dd2bca33252e5cd192"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "40G"
vm_sockets            = "1"
os                    = "win10"
vm_disk_format        = "raw"
