# Portfolio Project - Toronto-Shared-Bike: Testing

[Back](../README.md)

- [Portfolio Project - Toronto-Shared-Bike: Testing](#portfolio-project---toronto-shared-bike-testing)
  - [Performance Testing](#performance-testing)
    - [K6](#k6)

---

## Performance Testing

| Type               | Category               | Subcategory         | Goal                                                            |
| ------------------ | ---------------------- | ------------------- | --------------------------------------------------------------- |
| `Smoke Testing`    | Functional Testing     | -                   | Verify basic functionality to ensure major features work.       |
| `Baseline Testing` | Non-Functional Testing | Performance Testing | Establish a performance benchmark for normal conditions.        |
| `Load Testing`     | Non-Functional Testing | Performance Testing | Evaluate performance under expected or peak loads.              |
| `Stress Testing`   | Non-Functional Testing | Performance Testing | Identify breaking points and recovery under extreme conditions. |
| `Soak Testing`     | Non-Functional Testing | Performance Testing | Ensure long-term stability under sustained typical loads.       |

---

### K6

```sh
cd testing/load
docker build -t k6 .

# smoke testing
docker run --rm --name k6_con --env-file ./.env -v ./:/app k6 cloud run --include-system-env-vars=true cloud_smoke.js

# load testing
docker run --rm --name k6_con --env-file ./.env -v ./:/app k6 cloud run --include-system-env-vars=true cloud_load.js

# stress testing
docker run --rm --name k6_con --env-file ./.env -v ./:/app k6 cloud run --include-system-env-vars=true cloud_stress.js

# spike testing
docker run --rm --name k6_con --env-file ./.env -v ./:/app k6 cloud run --include-system-env-vars=true cloud_spike.js

# stress testing local
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=stress.html -v ./:/app k6 run local_stress.js

# spike testing local
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=spike.html -v ./:/app k6 run local_spike.js

# breakpoint testing
docker run --rm --name k6_con -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=breakpoint.html -v ./:/app k6 run local_breakpoint.js
```

---