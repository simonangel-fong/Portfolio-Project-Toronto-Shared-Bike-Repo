


```sh
docker compose down -v && docker compose up -d

# etl
docker exec -it postgresql bash /scripts/etl/pipeline.sh





git clone -b feature-dw-dev https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git .
git checkout feature-dw-dev
pwd
ls -l


HOST_JENKINS_HOME=$(docker inspect jenkins --format '{{range .Mounts}}{{if eq .Destination "/var/jenkins_home"}}{{.Source}}{{end}}{{end}}')
DIR_PGDB="$HOST_JENKINS_HOME/workspace/$JOB_NAME/data-warehouse/postgresql"

echo $DIR_PGDB
export DIR_PGDB

ls -l $DIR_PGDB

# cd data-warehouse/postgresql
# docker --version
# docker compose down -v
# docker compose up -d
```
