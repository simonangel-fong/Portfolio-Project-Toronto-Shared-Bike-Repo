#!/bin/bash

PROMETHEUS_FILE="data-warehouse/monitor/docker-compose.yaml"

echo
echo "##############################"
echo "remove exiting docker"
echo "##############################"
echo

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo
echo "##############################"
echo "Install Docker"
echo "##############################"
echo

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
sudo chmod 666 /var/run/docker.sock

sudo systemctl enable --now docker

echo
echo "##############################"
echo "Verify Docker"
echo "##############################"
echo

docker --version
docker run hello-world

echo
echo "##############################"
echo "Install Jenkins"
echo "##############################"
echo
# Installation of Java
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre
java -version
openjdk version "21.0.3" 2024-04-16
OpenJDK Runtime Environment (build 21.0.3+11-Debian-2)
OpenJDK 64-Bit Server VM (build 21.0.3+11-Debian-2, mixed mode, sharing)

# Install Jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

# verify
jenkins --version
# add jenkins user to docker
sudo usermod -aG docker jenkins

echo
echo "##############################"
echo "Start Prometheus & Grafana"
echo "##############################"
echo
# spin up Prometheus
docker compose -f $PROMETHEUS_FILE down
docker compose -f $PROMETHEUS_FILE  up -d --build
# docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword