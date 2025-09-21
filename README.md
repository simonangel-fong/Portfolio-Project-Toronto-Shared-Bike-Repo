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
