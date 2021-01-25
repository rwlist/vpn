# vpn
Various scripts for VPN management

## Deploy WireGuard to Yandex.Cloud

1. Create an account and fill secrets in `tf/secrets.env`

```
export YC_TOKEN=
export YC_CLOUD_ID=
export YC_FOLDER_ID=
```

2. Run scripts

```
cd yandex/wireguard

# init yandex provider
source secrets.env && terraform init

# run terraform to prepare infra
source secrets.env && terraform apply

# ssh to server and run:
export SERVER_IP=
curl https://raw.githubusercontent.com/rwlist/vpn/master/scripts/wrg.sh > wrg.sh
chmod +x wrg.sh
./wrg.sh init_module
./wrg.sh init_files
./wrg.sh copy_files
./wrg.sh system_run
./wrg.sh qrcode client2.conf
```
