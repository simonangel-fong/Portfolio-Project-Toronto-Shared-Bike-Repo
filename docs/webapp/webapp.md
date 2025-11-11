```sh
cd web-app/lambda

python -m venv .venv
python -m pip install --upgrade pip

pip install -r requirements.txt

# unit test
pytest
```

---

```sh
cd web-app/aws

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform plan
terraform apply -auto-approve

terraform destroy -auto-approve

# test
cd testing/load
docker build -t k6 .

# cloud
docker run --rm --name k6_con --env-file ./.env -e TEST="API(Dev) Smoke Test" -e DOMAIN=trip-dev.arguswatcher.net -v ./:/app k6 cloud run --include-system-env-vars=true cloud_smoke.js

docker run --rm --name k6_con --env-file ./.env -e TEST="Dev-API-Stress-Testing" -e VU=100 -e SCALE=1 -e DURATION=10 -e DOMAIN=https://trip-dev.arguswatcher.net/ -v ./:/app k6 cloud run --include-system-env-vars=true cloud_stress.js


```
