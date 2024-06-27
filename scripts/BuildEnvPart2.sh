#!/bin/bash

set -euo pipefail

# Function to handle errors
handle_error() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Part 2: ANSIBLE
python3 -m venv /root/GitProject/ProxmoxAutoADEnv/venv
source /root/GitProject/ProxmoxAutoADEnv/venv/bin/activate

python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6 pywinrm

source /root/GitProject/ProxmoxAutoADEnv/scripts/Ansible-Install.sh

# Part 3: PACKER & TERRAFORM
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install -y packer terraform

# Part 4: Download Cloudbase-Init MSI
cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/scripts/sysprep/
wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi

# Download ISO files
cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/iso
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso &
wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso &
wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso &
wait

# Part 5: SCP files
scp /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/iso/* root@192.168.10.20:/path/to/destination
