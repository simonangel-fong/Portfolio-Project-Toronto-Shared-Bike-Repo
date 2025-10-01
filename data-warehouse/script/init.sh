#!/bin/bash

set -euo pipefail

DIR_HOME=/home/ubuntuadmin
DIR_PROJECT=$DIR_HOME/project_shared_bike
GITHUB_REPO=https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git

SCRIPT_MONITOR=$DIR_PROJECT/data-warehouse/script/start_monitor_docker.sh
SCRIPT_JENKINS=$DIR_PROJECT/data-warehouse/script/start_jenkins.sh

echo
echo "##############################"
echo "Update apt"
echo "##############################"
echo
sudo apt-get update && sudo apt-get upgrade -y

echo
echo "##############################"
echo "Git Clone Repo"
echo "##############################"
echo
sudo apt install -y git
rm -rf $DIR_PROJECT
mkdir -pv $DIR_PROJECT
git clone $GITHUB_REPO $DIR_PROJECT

echo
echo "##############################"
echo "Install Docker"
echo "##############################"
echo

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable --now docker

# confirm
docker --version
sudo usermod -aG docker $USER

cd $DIR_PROJECT
git checkout feature/dw

# start prometheus
bash $SCRIPT_MONITOR
# start jenkins
bash $SCRIPT_JENKINS
