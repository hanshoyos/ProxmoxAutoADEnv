My Version of GOAD Repository Setup and Proxmox Cloud-Init Template Creation

This guide will walk you through setting up the GOAD repository and creating a Proxmox Cloud-Init template using Packer.

Step-by-Step Instructions

Initial Update

apt update && apt upgrade
Install Project Dependencies

apt install git vim tmux curl gnupg software-properties-common mkisofs
Add HashiCorp GPG Key and Repository

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer terraform
Install Python and PIP

apt install python3-pip
Set Up Python Virtual Environment

mkdir GitProject
cd GitProject
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6
python3 -m pip install pywinrm
Clone the ProxmoxAutoADEnv Repository

git clone https://github.com/hanshoyos/ProxmoxAutoADEnv.git
cd ProxmoxAutoADEnv/iso
Download Required ISO Files

wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso
Download Cloudbase-Init MSI

cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/scripts/sysprep/
wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi
Create a Dedicated Proxmox User and Role

pveum useradd infra_as_code@pve
pveum passwd infra_as_code@pve
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
pveum acl modify / -user 'infra_as_code@pve' -role Packer
Configure Packer Variables

cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox
cp config.auto.pkrvars.hcl.template config.auto.pkrvars.hcl
# Edit config.auto.pkrvars.hcl with your Proxmox details
Build Proxmox ISO

./build_proxmox_iso.sh
Copy ISOs to Proxmox Node

scp /root/GitProject/ProxmoxAutoADEnv/iso/* infra_as_code@proxmox-node:/var/lib/vz/template/iso/
Initialize and Build Packer Template

cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox
packer init .
packer validate -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
packer build -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
Explanation

Initial Update: Update and upgrade the system packages to the latest versions.
Install Project Dependencies: Install necessary tools and dependencies for the project.
Add HashiCorp GPG Key and Repository: Add the HashiCorp repository and install Packer and Terraform.
Install Python and PIP: Install Python 3 and PIP for managing Python packages.
Set Up Python Virtual Environment: Create and activate a Python virtual environment, then install Ansible and pywinrm.
Clone the ProxmoxAutoADEnv Repository: Clone the repository containing Proxmox automation scripts.
Download Required ISO Files: Download the VirtIO driver and Windows ISO files.
Download Cloudbase-Init MSI: Download the Cloudbase-Init MSI for Windows initialization.
Create a Dedicated Proxmox User and Role: Create a user and assign a role with the necessary permissions for Packer to interact with Proxmox.
Configure Packer Variables: Copy and edit the Packer variable configuration file with your Proxmox details.
Build Proxmox ISO: Run the script to create ISO files needed for Packer to build the template.
Copy ISOs to Proxmox Node: Transfer the ISO files to the Proxmox server.
Initialize and Build Packer Template: Initialize and run Packer to create the Proxmox template.
This guide covers the steps needed to set up your environment, create a Proxmox Cloud-Init template using Packer, Later we will ensure that everything is configured correctly for further automation with Terraform and Ansible.
