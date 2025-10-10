

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