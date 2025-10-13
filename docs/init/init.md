# On-premises Deployment - Initialize VM

[Back](../../README.md)

- [On-premises Deployment - Initialize VM](#on-premises-deployment---initialize-vm)
  - [Initialize VM](#initialize-vm)
  - [Auto Deploy](#auto-deploy)

---

## Initialize VM

- Setup SSH

```sh
#
ssh -J root@192.168.1.80 admin@192.168.100.110
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y openssh-server vim

# enable pwd auth
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication yes

# restart ssh service
sudo systemctl enable --now ssh
sudo systemctl restart ssh
```

- configure ip

```sh
sudo touch /etc/netplan/01-netcfg.yaml
sudo tee /etc/netplan/01-netcfg.yaml << EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - 192.168.100.110/24
      routes:
        - to: default
          via: 192.168.100.254
      nameservers:
        addresses: [192.168.100.254, 8.8.8.8]
EOF

sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply

sudo reboot
```

---

## Auto Deploy

```sh
# upload init script to vm
# scp ./init.sh ubuntuadmin@on-prem:~
scp -r -o ProxyJump=root@192.168.1.80 ./init.sh root@192.168.100.110:~

# connect with vm
# ssh ubuntuadmin@on-prem
ssh -J root@192.168.1.80 root@192.168.100.110

# initialize app code
bash init.sh

# set env
vi ~/project_shared_bike/data-warehouse/cloudflare/.env
vi ~/project_shared_bike/data-warehouse/jenkins/.env
```
