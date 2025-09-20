#!/bin/bash

mkdir -pv ~/project_toronto_shared_bike
cd ~/project_toronto_shared_bike
git clone https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git ~/project_toronto_shared_bike


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

# add current user
sudo usermod -aG docker $USER

docker --version

# install Jenkins with docker
mkdir -pv ~/jenkins
cd ~/jenkins

cat > docker-compose.yaml<<EOF
services:
  jenkins:
    container_name: jenkins
    restart: unless-stopped
    image: jenkins/jenkins
    # privileged: true
    # user: root
    ports:
      - "8080:8080"
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - net
networks:
  net:
EOF
