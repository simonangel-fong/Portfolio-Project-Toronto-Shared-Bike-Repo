# Testing

[Back](../../README.md)

- [Testing](#testing)
  - [Unit Test](#unit-test)
  - [Performance Testing](#performance-testing)
    - [K6](#k6)

---

## Unit Test

```sh
# setup env
python -m venv .venv

# activate env
.venv\Scripts\activate.bat
# .venv\Scripts\deactivate.bat

# install packages
pip install --upgrade pip
pip install pytest moto boto3

# unit test
pytest
# ================================== test session starts ==================================
# platform win32 -- Python 3.11.0rc2, pytest-8.4.2, pluggy-1.6.0
# rootdir: C:\Users\simon\OneDrive\Tech\Github\Portfolio-Project-Toronto-Shared-Bike-Infra-Repo
# collected 13 items

# testing\unit\test_bike.py ..                                                       [ 15%]
# testing\unit\test_station.py ..                                                    [ 30%]
# testing\unit\test_top_station.py ...                                               [ 53%]
# testing\unit\test_trip_hour.py ...                                                 [ 76%]
# testing\unit\test_trip_month.py ...                                                [100%]

# ================================== 13 passed in 2.22s ===================================
```

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
