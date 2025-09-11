# Portfolio Project - Toronto-Shared-Bike: Testing

[Back](../README.md)

- [Portfolio Project - Toronto-Shared-Bike: Testing](#portfolio-project---toronto-shared-bike-testing)
  - [Testing](#testing)
  - [K6](#k6)

---

## Testing

| Type               | Category               | Subcategory         | Goal                                                            |
| ------------------ | ---------------------- | ------------------- | --------------------------------------------------------------- |
| `Smoke Testing`    | Functional Testing     | -                   | Verify basic functionality to ensure major features work.       |
| `Baseline Testing` | Non-Functional Testing | Performance Testing | Establish a performance benchmark for normal conditions.        |
| `Load Testing`     | Non-Functional Testing | Performance Testing | Evaluate performance under expected or peak loads.              |
| `Stress Testing`   | Non-Functional Testing | Performance Testing | Identify breaking points and recovery under extreme conditions. |
| `Soak Testing`     | Non-Functional Testing | Performance Testing | Ensure long-term stability under sustained typical loads.       |

---

## K6

```sh
cd test
docker build -t k6 .

# smoke testing
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_smoke.js

# load testing
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_load.js

# stress testing
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_stress.js

# spike testing
docker run --rm --name k6_con --env-file ./.env -v ./script:/app k6 cloud run cloud_spike.js

# stress testing local
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=stress.html -v ./script:/app k6 run local_stress.js

# spike testing local
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=spike.html -v ./script:/app k6 run local_spike.js

# breakpoint testing
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=breakpoint.html -v ./script:/app k6 run local_breakpoint.js
```
