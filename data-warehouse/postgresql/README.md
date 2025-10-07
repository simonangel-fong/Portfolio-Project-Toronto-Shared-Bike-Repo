


```sh
docker imges


docker build -t shared_bike_pg:latest .
docker rm pgdb && 
docker run -d --rm --name pgdb -p 5432:5432 -e POSTGRES_USER=postgres shared_bike_pg:latest

docker compose up -d
```
