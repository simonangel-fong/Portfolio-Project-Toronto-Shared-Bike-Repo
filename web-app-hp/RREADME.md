

```sh
cd testing

docker run --rm --name k6_con --env-file ./.env -e TESTING_NAME="API Base Testing" -e DNS_DOMAIN=trip-base.arguswatcher.net -e API_ENV=base -v ./:/app k6 cloud run --include-system-env-vars=true cloud_hp.js

docker run --rm --name k6_con --env-file ./.env -e TESTING_NAME="API HP Testing" -e DNS_DOMAIN=trip-hp.arguswatcher.net -e API_ENV=hp -v ./:/app k6 cloud run --include-system-env-vars=true cloud_hp.js
```