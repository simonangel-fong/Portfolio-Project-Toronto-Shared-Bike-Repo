# Portfolio Project - Toronto-Shared-Bike

- [Portfolio Project - Toronto-Shared-Bike](#portfolio-project---toronto-shared-bike)
  - [Architecture](#architecture)
  - [Website](#website)
  - [API Gateway](#api-gateway)
  - [Testing](#testing)
  - [K6](#k6)

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

## K6

```sh
cd k6
docker build -t k6 .

# smoke testing
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_smoke.js

# load testing: 20
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_load_20.js

# stress testing: 100 vu
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_stress.js

# stress testing: 200 vu
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=stress_200.html -v ./script:/app k6 run local_stress_200.js

# spike testing: 2000vu
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=spike_2000.html -v ./script:/app k6 run local_spike_2000.js

# breakpoint testing: 2000vu
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=breakpoint.html -v ./script:/app k6 run local_breakpoint_2000.js
```
