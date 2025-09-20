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

# create dir for persistence
mkdir -pv jenkins_home
chown $USER:$USER -Rv jenkins_home

sudo docker compose up -d

# install prometheus
mkdir -pv ~/monitoring
cd ~/monitoring

sudo docker network create monitoring

tee docker-compose.yml<<EOF

services:
    node-exporter:
        container_name: node-exporter
        image: prom/node-exporter
        ports:
            - 9100:9100
        restart: unless-stopped
        networks:
            - monitoring
        volumes:
            - /proc:/host/proc:ro
            - /sys:/host/sys:ro
            - /:/rootfs:ro
        command:
            - '--path.procfs=/host/proc'
            - '--path.sysfs=/host/sys'
            - '--path.rootfs=/rootfs'
            - '--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)'

    prometheus:
        container_name: prometheus
        image: prom/prometheus
        volumes:
            - "./prometheus.yml:/etc/prometheus/prometheus.yml"
            - prometheus_data:/prometheus
        ports:
            - 9090:9090
        restart: unless-stopped
        networks:
            - monitoring

    grafana:
        container_name: grafana
        image: grafana/grafana
        ports:
            - 3000:3000
        environment:
            - GF_SECURITY_ADMIN_PASSWORD=admin # Change this in production
        volumes:
            - grafana_data:/var/lib/grafana
        restart: unless-stopped
        networks:
            - monitoring

networks:
    monitoring:
        driver: bridge

volumes:
    prometheus_data: {}
    grafana_data: {}
EOF

tee prometheus.yml<<EOF

global:
  scrape_interval: 10s
scrape_configs:
 - job_name: prometheus
   static_configs:
      - targets:
        - prometheus:9090

  - job_name: 'node-exporter'
    static_configs:
      - targets: 
        - node-exporter:9100

 
EOF

sudo docker compose up -d --build




