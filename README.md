# Portfolio Project - Toronto-Shared-Bike

- [Portfolio Project - Toronto-Shared-Bike](#portfolio-project---toronto-shared-bike)
  - [System Architecture](#system-architecture)
  - [Web Application](#web-application)

---

## System Architecture

![sa](./src/web-app/html/img/tech/system_design.gif)

---

## Web Application

- Web: [https://trip.arguswatcher.net](https://trip.arguswatcher.net)

- RESTful API

| Url                                      | Description                          |
| ---------------------------------------- | ------------------------------------ |
| `trip.arguswatcher.net/prod/bike`        | Shared bike number over years        |
| `trip.arguswatcher.net/prod/station`     | Bike station number over years       |
| `trip.arguswatcher.net/prod/trip-hour`   | Hourly pattern of shared-bike trips  |
| `trip.arguswatcher.net/prod/trip-month`  | Monthly pattern of shared-bike trips |
| `trip.arguswatcher.net/prod/top-station` | Top 10 stations                      |

---

- [Testing with `k6`](./docs/test.md)

```sh
mkdir -pv ~/project_toronto_shared_bike
sudo apt install -y git
git clone https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git ~/project_toronto_shared_bike

cd ~/project_toronto_shared_bike
git checkout feature/dw
chmod -v +x ~/project_toronto_shared_bike/data-warehouse/script/init.sh

bash data-warehouse/script/init.sh
# get jenkins pwd
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```


```sh
sudo apt update
sudo apt install -y openssh-server 
sudo systemctl enable --now ssh

sudo vi /etc/ssh/sshd_config
sudo systemctl restart ssh
```




                                ┌───────────────────────────────────────────┐
                                │                 Client                    │
                                │  (your browser/CLI hitting Jenkins UI)    │
                                └───────────────────────────────────────────┘
                                                     │ HTTPS
                                                     ▼
┌───────────────────────────────────────────────────────────────────────────────────────────────┐
│                                           VM (Host)                                           │
│                                                                                               │
│  ┌───────────────────────────┐                     Control (SSH)                              │
│  │   Reverse Proxy (opt.)    │◀────────────────────────────────────────────────────────────┐  │
│  │  (nginx/traefik + TLS)    │                                                            │  │
│  └─────────────▲─────────────┘                                                            │  │
│                │ HTTP (internal)                                                          │  │
│  ┌─────────────┴───────────────────────────────────────────┐                              │  │
│  │                 Jenkins Controller (Docker)              │                              │  │
│  │   container: jenkins:lts-jdk17                           │                              │  │
│  │   volume: jenkins_home  (JENKINS_HOME persistence)       │                              │  │
│  │   NO /var/run/docker.sock mount (best practice)          │                              │  │
│  └─────────────┬────────────────────────────────────────────┘                              │  │
│                │ Schedules jobs                                                                 │
│                │                                                                                │
│                │                  ┌─────────────────────────────────────────────────────────┐   │
│                └─────────────────▶│     Jenkins Agent (VM host via SSH)                     │   │
│                                   │  user: jenkins (member of docker group)                │   │
│                                   │  runs pipelines; sees host FS (/srv/etl)               │   │
│                                   └───────────┬────────────────────────────────────────────┘   │
│                                               │ orchestrates docker compose, psql, file IO      │
│                                               │                                                 │
│                          ┌────────────────────▼────────────────────┐                            │
│                          │            Docker Engine                │                            │
│                          │        (running on the VM host)         │                            │
│                          └───────┬───────────────────┬─────────────┘                            │
│                                  │                   │                                          │
│   ┌───────────────────────────────▼─────────────┐     │                                          │
│   │              pgdb Compose Stack             │     │                                          │
│   │  service: db (postgres:16)                  │     │                                          │
│   │  healthcheck: pg_isready                    │     │                                          │
│   │  volumes:                                   │     │                                          │
│   │    • pgdata (named volume)  ────────────────┘     │   durable database files                 │
│   │    • ../data (bind mount)  <──────────────────────┘   raw/export visible on host + container │
│   │    • ../sql/init (ro)      <──────────────────────── init SQL (schemas/users/extensions)     │
│   │    • ../sql/transform (ro) <──────────────────────── ETL SQL (idempotent transforms)        │
│   └─────────────────────────────────────────────────────────────────────────────────────────────┘
│
│   Host filesystem layout (owned by jenkins:docker):
│     /srv/etl/
│       compose/  (docker-compose.yml, .env from Jenkins creds)
│       data/
│         raw/      ← CSV inputs downloaded by pipeline
│         export/   → processed outputs & backups (pg_dump)
│       sql/
│         init/     ← first-boot schema/users
│         transform/← idempotent ETL scripts
│       cache/      ← ETag/checksum for idempotent downloads
│       logs/
│
│   External data flows:
│     [CSV Source: HTTPS/S3/etc.] ───────────────▶ /srv/etl/data/raw/      (download step, cache-aware)
│     /srv/etl/data/export/ ─────────────────────▶ [Downstream consumer or S3 backup (optional)]
│
└───────────────────────────────────────────────────────────────────────────────────────────────┘

```sh
apt update
apt install -y openjdk-17-jre openssh-server
# Create a work dir for Jenkins builds:
useradd -m -s /bin/bash jenkins || true
mkdir -p /home/jenkins/agent && chown -R jenkins:jenkins /home/jenkins
```


dockerfile

```sh
docker run -e POSTGRES_USER="postgres" -e POSTGRES_PASSWORD="SecurePassword123" -e POSTGRES_DB="toronto_shared_bike" -v ./scripts/setup:/docker-entrypoint-initdb.d -v ./scripts:/scripts --name "dw" -d postgres:15
```
