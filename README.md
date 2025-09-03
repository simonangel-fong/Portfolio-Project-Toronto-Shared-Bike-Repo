# Portfolio Project - Toronto-Shared-Bike

- [Portfolio Project - Toronto-Shared-Bike](#portfolio-project---toronto-shared-bike)
  - [Architecture](#architecture)
  - [Website](#website)
  - [API Gateway](#api-gateway)
  - [Testing](#testing)

---

## Architecture

![sa](./web/img/tech/system_design.gif)

---

## Website

- Domain: [https://trip.arguswatcher.net](https://trip.arguswatcher.net)

---

## API Gateway

| Url                                      | Description                          |
| ---------------------------------------- | ------------------------------------ |
| `trip.arguswatcher.net/prod/bike`        | Shared bike number over years        |
| `trip.arguswatcher.net/prod/station`     | Bike station number over years       |
| `trip.arguswatcher.net/prod/trip-hour`   | Hourly pattern of shared-bike trips  |
| `trip.arguswatcher.net/prod/trip-month`  | Monthly pattern of shared-bike trips |
| `trip.arguswatcher.net/prod/top-station` | Top 10 stations                      |

---

## Testing

| Type               | Category               | Subcategory         | Goal                                                            |
| ------------------ | ---------------------- | ------------------- | --------------------------------------------------------------- |
| `Smoke Testing`    | Functional Testing     | -                   | Verify basic functionality to ensure major features work.       |
| `Baseline Testing` | Non-Functional Testing | Performance Testing | Establish a performance benchmark for normal conditions.        |
| `Load Testing`     | Non-Functional Testing | Performance Testing | Evaluate performance under expected or peak loads.              |
| `Stress Testing`   | Non-Functional Testing | Performance Testing | Identify breaking points and recovery under extreme conditions. |
| `Soak Testing`     | Non-Functional Testing | Performance Testing | Ensure long-term stability under sustained typical loads.       |

```sh
cd locust
docker compose down && docker compose up -d --scale worker=2

# smoke Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 2 -r 2 --host https://trip.arguswatcher.net --run-time 2m --html /mnt/locust/html/smoke.html --csv /mnt/locust/csv/smoke

# baseline Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 50 -r 1 --host https://trip.arguswatcher.net --run-time 2m --html /mnt/locust/html/baseline.html --csv /mnt/locust/csv/baseline

# load Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 100 -r 5 --host https://trip.arguswatcher.net --run-time 5m --html /mnt/locust/html/load_100.html --csv /mnt/locust/csv/load_100

# load Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 300 -r 5 --host https://trip.arguswatcher.net --run-time 5m --html /mnt/locust/html/load_300.html --csv /mnt/locust/csv/load_300

# load Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 500 -r 5 --host https://trip.arguswatcher.net --run-time 5m --html /mnt/locust/html/load_500.html --csv /mnt/locust/csv/load_500

# Stress Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 1000 -r 20 --host https://trip.arguswatcher.net --run-time 5m --html /mnt/locust/html/load_1000.html --csv /mnt/locust/csv/load_1000

# Soak Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 200 -r 20 --host https://trip.arguswatcher.net --run-time 10m --html /mnt/locust/html/soak_200_10m.html --csv /mnt/locust/csv/soak_200_10m
```
