# On-premises Deployment - Data Warehouse

[Back](../../README.md)

- [On-premises Deployment - Data Warehouse](#on-premises-deployment---data-warehouse)
  - [Deploy Application](#deploy-application)

---

## Deploy Application

```sh
# upload init script to vm
scp -r -o ProxyJump=root@192.168.1.80 ./init.sh root@192.168.100.110:~

# connect with vm
ssh -J root@192.168.1.80 root@192.168.100.110

bash init.sh
```
