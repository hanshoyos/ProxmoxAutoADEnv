#!/bin/bash

set -e

# Function to display error message and exit
error_exit() {
  echo "$1" 1>&2
  exit 1
}

# Function to update and upgrade the system
update_system() {
  echo "Updating and upgrading the system..."
  sudo apt update && sudo apt upgrade -y || error_exit "System update and upgrade failed."
  sudo apt install -y git gpg vim tmux curl gnupg software-properties-common mkisofs python3-venv || error_exit "Failed to install required packages."
}

# Function to setup the project
setup_project() {
  echo "Setting up project directory and cloning repository..."
  cd /root
  git clone https://github.com/hanshoyos/ProxmoxAutoADEnv.git || error_exit "Failed to clone repository."
}

# Function to create and activate Python virtual environment
create_venv() {
  echo "Creating and activating Python virtual environment..."
  python3 -m venv /root/ProxmoxAutoADEnv/venv || error_exit "Failed to create Python virtual environment."
  source /root/ProxmoxAutoADEnv/venv/bin/activate || error_exit "Failed to activate Python virtual environment."
}

# Function to install Ansible
install_ansible() {
  echo "Installing Ansible..."
  source /root/ProxmoxAutoADEnv/scripts/Ansible-Install.sh || error_exit "Failed to install Ansible."
}

# Function to install Packer and Terraform
install_packer_terraform() {
  echo "Installing Packer and Terraform..."
  source /root/ProxmoxAutoADEnv/scripts/Install-Packer-Terraform.sh || error_exit "Failed to install Packer and Terraform."
}

# Function to download Cloudbase-Init MSI
download_cloudbase_init() {
  echo "Downloading Cloudbase-Init MSI..."
  cd /root/ProxmoxAutoADEnv/packer/proxmox/scripts/sysprep/
  wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi || error_exit "Failed to download Cloudbase-Init MSI."
}

# Function to download ISO files on Proxmox server
download_iso_files_proxmox() {
  echo "Downloading ISO files on Proxmox server..."
  ssh root@192.168.10.20 << 'EOF'
cd /var/lib/vz/template/iso/ || exit 1
nohup wget -O virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso &
nohup wget -O windows10.iso https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso &
nohup wget -O windows_server_2019.iso https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso &
EOF
  # Wait for downloads to complete
  echo "Waiting for ISO downloads to complete..."
  sleep 60
}

# Function to run build_proxmox_iso.sh script
build_proxmox_iso() {
  echo "Running build_proxmox_iso.sh script..."
  source /root/ProxmoxAutoADEnv/packer/proxmox/build_proxmox_iso.sh || error_exit "Failed to build Proxmox ISO."
}

# Function to SCP files to Proxmox server
scp_files_to_proxmox() {
  echo "Copying ISO files to Proxmox server..."
  scp /root/ProxmoxAutoADEnv/packer/proxmox/iso/* root@192.168.10.20:/var/lib/vz/template/iso/ || error_exit "Failed to copy ISO files to Proxmox server."
}

# Function to setup Proxmox user and roles
setup_proxmox_user() {
  echo "Setting up Proxmox user and roles..."
  ssh root@192.168.10.20 << 'EOF'
pveum useradd infra_as_code@pve
pveum passwd infra_as_code@pve
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
pveum acl modify / -user 'infra_as_code@pve' -role Packer
EOF
}

# Display menu
show_menu() {
  echo "Choose an option:"
  echo "1) Update and upgrade the system"
  echo "2) Setup project"
  echo "3) Create and activate Python virtual environment"
  echo "4) Install Ansible"
  echo "5) Install Packer and Terraform"
  echo "6) Download Cloudbase-Init MSI"
  echo "7) Download ISO files on Proxmox server"
  echo "8) Build Proxmox ISO"
  echo "9) SCP files to Proxmox server"
  echo "10) Setup Proxmox user and roles"
  echo "11) Exit"
  read -p "Enter choice [1-11]: " choice
  case $choice in
    1) update_system ;;
    2) setup_project ;;
    3) create_venv ;;
    4) install_ansible ;;
    5) install_packer_terraform ;;
    6) download_cloudbase_init ;;
    7) download_iso_files_proxmox ;;
    8) build_proxmox_iso ;;
    9) scp_files_to_proxmox ;;
    10) setup_proxmox_user ;;
    11) exit 0 ;;
    *) echo "Invalid choice!"; show_menu ;;
  esac
}

# Show the menu until the user exits
while true; do
  show_menu
done
