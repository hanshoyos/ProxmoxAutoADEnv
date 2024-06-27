#!/bin/bash

set -euo pipefail

# Function to handle errors
handle_error() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Part 1: Update and upgrade the system
sudo apt update && sudo apt upgrade -y
sudo apt install -y git gpg vim tmux curl gnupg software-properties-common mkisofs python3-venv


# PROJECT SETUP
mkdir -p /root/GitProject
cd /root/GitProject
git clone https://github.com/hanshoyos/ProxmoxAutoADEnv.git

# Execute the second script
source /root/GitProject/ProxmoxAutoADEnv/scripts/BuildEnvPart2.sh
