### My Version of GOAD Repository Setup and Proxmox Cloud-Init Template Creation

This guide will walk you through setting up the GOAD repository and creating a Proxmox Cloud-Init template using Packer.

#### Step-by-Step Instructions

1. **Initial Update**
   ```bash
   apt update && apt upgrade
   ```

2. **Install Project Dependencies**
   ```bash
   apt install git vim tmux curl gnupg software-properties-common mkisofs
   ```

3. **Add HashiCorp GPG Key and Repository**
   ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install packer terraform
   ```

4. **Install Python and PIP**
   ```bash
   apt install python3-pip
   ```

5. **Set Up Python Virtual Environment**
   ```bash
   mkdir GitProject
   cd GitProject
   python3 -m venv venv
   source venv/bin/activate
   python3 -m pip install --upgrade pip
   python3 -m pip install ansible-core==2.12.6
   python3 -m pip install pywinrm
   ```

6. **Clone the ProxmoxAutoADEnv Repository**
   ```bash
   git clone https://github.com/hanshoyos/ProxmoxAutoADEnv.git
   cd ProxmoxAutoADEnv/iso
   ```

7. **Download Required ISO Files**
   ```bash
   wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
   wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
   wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
   wget https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso
   ```

8. **Download Cloudbase-Init MSI**
   ```bash
   cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox/scripts/sysprep/
   wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi
   ```

9. **Create a Dedicated Proxmox User and Role**
   ```bash
   pveum useradd infra_as_code@pve
   pveum passwd infra_as_code@pve
   pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
   pveum acl modify / -user 'infra_as_code@pve' -role Packer
   ```

10. **Configure Packer Variables**
    ```bash
    cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox
    cp config.auto.pkrvars.hcl.template config.auto.pkrvars.hcl
    # Edit config.auto.pkrvars.hcl with your Proxmox details
    ```

11. **Build Proxmox ISO**
    ```bash
    ./build_proxmox_iso.sh
    ```

12. **Copy ISOs to Proxmox Node**
    ```bash
    scp /root/GitProject/ProxmoxAutoADEnv/iso/* infra_as_code@proxmox-node:/var/lib/vz/template/iso/
    ```

13. **Initialize and Build Packer Template**
    ```bash
    cd /root/GitProject/ProxmoxAutoADEnv/packer/proxmox
    packer init .
    packer validate -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
    packer build -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
    ```

### Explanation

1. **Initial Update:** Update and upgrade the system packages to the latest versions.
2. **Install Project Dependencies:** Install necessary tools and dependencies for the project.
3. **Add HashiCorp GPG Key and Repository:** Add the HashiCorp repository and install Packer and Terraform.
4. **Install Python and PIP:** Install Python 3 and PIP for managing Python packages.
5. **Set Up Python Virtual Environment:** Create and activate a Python virtual environment, then install Ansible and pywinrm.
6. **Clone the ProxmoxAutoADEnv Repository:** Clone the repository containing Proxmox automation scripts.
7. **Download Required ISO Files:** Download the VirtIO driver and Windows ISO files.
8. **Download Cloudbase-Init MSI:** Download the Cloudbase-Init MSI for Windows initialization.
9. **Create a Dedicated Proxmox User and Role:** Create a user and assign a role with the necessary permissions for Packer to interact with Proxmox.
10. **Configure Packer Variables:** Copy and edit the Packer variable configuration file with your Proxmox details.
11. **Build Proxmox ISO:** Run the script to create ISO files needed for Packer to build the template.
12. **Copy ISOs to Proxmox Node:** Transfer the ISO files to the Proxmox server.
13. **Initialize and Build Packer Template:** Initialize and run Packer to create the Proxmox template.

This guide covers the steps needed to set up your environment, create a Proxmox Cloud-Init template using Packer, Later we will ensure that everything is configured correctly for further automation with Terraform and Ansible.
