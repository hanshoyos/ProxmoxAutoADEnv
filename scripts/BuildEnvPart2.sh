#!/bin/bash

set -euo pipefail

# Function to handle errors
handle_error() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Part 2: Create Dev Env and activate
python3 -m venv /root/GitProject/ProxmoxAutoADEnv/venv
source /root/GitProject/ProxmoxAutoADEnv/venv/bin/activate



# Part 3: Install Ansible from another script 
source /root/GitProject/ProxmoxAutoADEnv/scripts/Ansible-Install.sh
wait

This is the commands that script is running


#Dont need anymore since im using apt to install ansible.
#python3 -m pip install --upgrade pip
#python3 -m pip install ansible-core==2.12.6 pywinrm

# Part 3: PACKER & TERRAFORM
source /root/GitProject/ProxmoxAutoADEnv/scripts/Install-Packer-Terraform.sh
wait

# Part 4: Download Cloudbase-Init MSI
cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/scripts/sysprep/
wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi


# Download ISO files 
cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/iso
#wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso &
#wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso &
#wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso &
#wait

# or push the download to happen locally on the proxmox server (DEFAULT)
#make it a script that will choose between these two. 
ssh root@192.168.10.20 << 'EOF'
cd /var/lib/vz/template/iso/
nohup wget -O virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso 
nohup wget -O windows10.iso https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
nohup wget -O windows_server_2019.iso https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso 
EOF


# Part 5: SCP files
scp /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/iso/* root@192.168.10.20:/var/lib/vz/template/iso/
