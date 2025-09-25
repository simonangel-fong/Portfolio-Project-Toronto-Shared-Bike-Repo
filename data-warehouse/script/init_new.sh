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
sudo -H -u dw_admin bash -c 'cd /home/dw_admin/project; git checkout feature/dw' 
sudo -H -u dw_admin bash -c 'cd /home/dw_admin/project; ls data-warehouse/jenkins' 
