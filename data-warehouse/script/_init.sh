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
echo "Create DW admin"
echo "##############################"
echo
# Create dw_admin user
sudo useradd dw_admin -d /home/dw_admin -m -s /bin/bash
# set pwd
echo "dw_admin:SecurePassword1234" | sudo chpasswd

# create dir
sudo mkdir -pv /home/dw_admin/project       # project dir for code
sudo mkdir -pv /home/dw_admin/agent         # agent dir for jenkins
sudo mkdir -pv /home/dw_admin/.ssh          # .ssh dir for ssh

sudo chown -Rv dw_admin:dw_admin /home/dw_admin

echo
echo "##############################"
echo "Git Clone Repo"
echo "##############################"
echo
sudo apt install -y git
sudo -H -u dw_admin bash -c 'git clone https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git /home/dw_admin/project' 

echo
echo "##############################"
echo "Install packages"
echo "##############################"
echo
sudo bash /home/dw_admin/project/data-warehouse/script/install.sh
sudo sudo usermod -aG docker $USER
sudo sudo usermod -aG docker dw_admin

echo
echo "##############################"
echo "Start Jenkins"
echo "##############################"
echo
sudo -H -u dw_admin bash -c 'cd /home/dw_admin/project/data-warehouse/jenkins; git checkout feature/dw; git pull; docker compose up -d'

ssh-keygen -t rsa -f ~/.ssh/jenkins -q -N ""
ssh-copy-id -i ~/.ssh/jenkins.pub dw_admin@localhost
