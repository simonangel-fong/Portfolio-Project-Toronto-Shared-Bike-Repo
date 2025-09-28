#!/bin/bash

set -euo pipefail

echo
echo "##############################"
echo "Install Jenkins"
echo "##############################"
echo
# Installation of Java
sudo apt-get install -y fontconfig openjdk-21-jre
java -version

# Install Jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins
# verify
jenkins --version
# add jenkins user to docker
sudo usermod -aG docker jenkins

# stop jenkins for further config
sudo systemctl stop jenkins

echo
echo "##############################"
echo "Get Jenkins pwd"
echo "##############################"
echo

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo
echo "##############################"
echo "Install Jenkins Plugins"
echo "##############################"
echo
# install plugin manager
sudo mkdir -pv /opt/jenkins-plugin-manager
sudo curl -fsSL -o /opt/jenkins-plugin-manager/jenkins-plugin-manager.jar https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.13.2/jenkins-plugin-manager-2.13.2.jar
# copy plugin
sudo cp -v /home/ubuntuadmin/project_shared_bike/data-warehouse/jenkins/config/plugins.txt /var/lib/jenkins/plugins.txt
sudo chmod 600 /var/lib/jenkins/plugins.txt
sudo chown -Rv jenkins:jenkins /var/lib/jenkins/plugins.txt
# install plugins
sudo -u jenkins java \
  -jar /opt/jenkins-plugin-manager/jenkins-plugin-manager.jar \
  --war /usr/share/java/jenkins.war \
  --plugin-file /var/lib/jenkins/plugins.txt \
  --plugin-download-directory /var/lib/jenkins/plugins \
  --verbose

echo
echo "##############################"
echo "Configure jcasc"
echo "##############################"
echo
sudo mkdir -pv /var/lib/jenkins/casc_configs
sudo cp -v /home/ubuntuadmin/project_shared_bike/data-warehouse/jenkins/config/jenkins.yaml /var/lib/jenkins/casc_configs/jenkins.yaml
sudo chmod 600 /var/lib/jenkins/casc_configs/jenkins.yaml
sudo chown -Rv jenkins:jenkins /var/lib/jenkins/casc_configs

# java -Dcasc.jenkins.config=/var/lib/jenkins/casc_configs/jenkins.yaml -jar /usr/share/java/jenkins.war
# java -Djenkins.install.runSetupWizard=false -jar /usr/share/java/jenkins.war