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
docker compose down && docker compose up -d --scale worker=2

# smoke Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 2 -r 2 --host https://trip.arguswatcher.net --run-time 2m --html /mnt/locust/html/smoke.html --csv /mnt/locust/csv/smoke

# baseline Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 50 -r 1 --host https://trip.arguswatcher.net --run-time 2m --html /mnt/locust/html/baseline.html --csv /mnt/locust/csv/baseline

# load Testing
docker compose exec -it master locust -f /mnt/locust/locustfile.py --headless --expect-workers 2 -u 100 -r 1 --host https://trip.arguswatcher.net --run-time 2m --html /mnt/locust/html/load.html --csv /mnt/locust/csv/load

```
