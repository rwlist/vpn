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

# run deploy scripts
./deploy.sh
```

## Connect to wireguard

### Android

Scan QR-code.

### Linux

Use nmcli and wireguard plugin.
```
nmcli connection import type wireguard file clientX.conf
```

### Windows

Insert config into GUI app.
