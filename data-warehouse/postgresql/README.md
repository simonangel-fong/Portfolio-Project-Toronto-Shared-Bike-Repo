


```sh
docker imges



docker compose down -v && docker rmi toronto-shared-bike-postgresql-postgresql-db && docker compose up -d

# etl
docker exec -it postgresql bash /scripts/etl/pipeline.sh
```
