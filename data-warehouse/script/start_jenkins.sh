#!/bin/bash

set -euo pipefail

echo
echo "##############################"
echo "Install Jenkins"
echo "##############################"
echo
# Installation of Java
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre
java -version

# Install Jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
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
echo "Get Jenkins pwd"
echo "##############################"
echo

sudo cat /var/lib/jenkins/secrets/initialAdminPassword