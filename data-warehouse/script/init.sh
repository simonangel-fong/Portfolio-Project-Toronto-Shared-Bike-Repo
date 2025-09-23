#!/bin/bash

set -euo pipefail

echo
echo "##############################"
echo "Update apt"
echo "##############################"
echo
sudo apt update && sudo apt upgrade -y

echo
echo "##############################"
echo "Set IP"
echo "##############################"
echo
sudo touch /etc/netplan/01-netcfg.yaml
sudo tee /etc/netplan/01-netcfg.yaml << EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.100.110/24
      routes:
        - to: default
          via: 192.168.100.254
      nameservers:
        addresses: [192.168.100.254, 8.8.8.8]
EOF

sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply

echo
echo "##############################"
echo "Git Clone Repo"
echo "##############################"
echo
sudo apt install -y git
rm -rf ~/project-shared-bike
mkdir -pv ~/project-shared-bike
git clone https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git ~/project-shared-bike

cd ~/project-shared-bike
git checkout feature/dw
bash ~/project-shared-bike/data-warehouse/script/install.sh
bash ~/project-shared-bike/data-warehouse/script/get_raw.sh

sudo mkdir -pv /export
sudo chown 999:999 /export

# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install

# aws --version