#!/bin/bash

set -euo pipefail

HOST_IP=192.168.100.110
HOST_IP_MASK=24
HOST_GATEWAY=192.168.100.254

USER_HOME=/home/ubuntuadmin
PROJECT_DIR=$USER_HOME/project_shared_bike
GITHUB_REPO=https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git

echo
echo "##############################"
echo "Update apt"
echo "##############################"
echo
sudo apt-get update && sudo apt-get upgrade -y

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
        - $HOST_IP/$HOST_IP_MASK
      routes:
        - to: default
          via: $HOST_GATEWAY
      nameservers:
        addresses: [$HOST_GATEWAY, 8.8.8.8]
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
# install package
bash $PROJECT_DIR/data-warehouse/script/install.sh
# start prometheus
bash $PROJECT_DIR/data-warehouse/script/start_monitor_docker.sh
# start jenkins
bash $PROJECT_DIR/data-warehouse/script/start_jenkins.sh
