

```sh
sudo mkdir -pv /var/jenkins_home/

cd /home/ubuntuadmin/project_shared_bike/data-warehouse/jenkins
docker compose up -d
```


```groovy
Jenkins.instance.pluginManager.plugins.each {
   println("${it.getShortName()}: ${it.getVersion()}")
}
```

```sh
cd ~/project_shared_bike/data-warehouse/cloudflare

git pull && sudo docker compose down -v && sudo docker compose up -d --build
```

```sh

```