


```sh
docker compose down -v && docker compose up -d

# etl
docker exec -it postgresql bash /scripts/etl/pipeline.sh




echo $HOST_WORKSPACE
git --version
git clone -b feature-dw-dev https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git .
git checkout feature-dw-dev
pwd
ls -l

echo "create test file"
ls -l data-warehouse/postgresql/scripts

cd data-warehouse/postgresql
docker --version
docker compose down -v
docker compose up -d
```
