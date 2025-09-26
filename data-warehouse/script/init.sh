#!/bin/bash

set -euo pipefail

PROJECT_DIR=/home/ubuntuadmin/project_shared_bike
GITHUB_REPO=https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git

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
rm -rf $PROJECT_DIR
mkdir -pv $PROJECT_DIR
git clone $GITHUB_REPO $PROJECT_DIR

cd $PROJECT_DIR
git checkout feature/dw
bash $PROJECT_DIR/data-warehouse/script/install.sh
bash $PROJECT_DIR/data-warehouse/script/start_prom.sh
bash $PROJECT_DIR/data-warehouse/script/start_jenkins.sh
