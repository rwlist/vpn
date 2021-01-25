#!/bin/bash
# wg.sh

set -e

PORT=6060
MAIN_ADDR=192.168.20.1
ALLOWED_IPS=192.168.20.0/24
# ALLOWED_IPS=0.0.0.0/0

SERVER_DIR=wgconf
CLIENT_DIR=.

init_module() {
    # docker run -it --rm --cap-add sys_module -v /lib/modules:/lib/modules cmulk/wireguard-docker:stretch install-module
	# apt update
	# apt install -y wireguard-dkms
	# sudo add-apt-repository -y ppa:wireguard/wireguard
	sudo apt update
	sudo apt install -y wireguard qrencode
}

init_files() {
    { read PRIVATE_KEY; read PUBLIC_KEY; } < <(gen_keys)

    mkdir -p $SERVER_DIR

cat > $SERVER_DIR/server.conf << EOF
[Interface]
Address = $MAIN_ADDR/24
PrivateKey = $PRIVATE_KEY
ListenPort = $PORT

EOF

    for cli in {2..16}
    do
        { read PRIVATE_CLI; read PUBLIC_CLI; } < <(gen_keys)

cat > client$cli.conf << EOF
[Interface]
PrivateKey = $PRIVATE_CLI
Address = 192.168.20.$cli/24

[Peer]
PublicKey = $PUBLIC_KEY
AllowedIPs = $ALLOWED_IPS
Endpoint = $SERVER_IP:$PORT
PersistentKeepalive = 25

EOF

cat >> ./wgconf/server.conf << EOF
[Peer]
PublicKey = $PUBLIC_CLI
AllowedIPs = 192.168.20.$cli

EOF

    done

}

copy_files() {
    sudo su << EOF
cp $SERVER_DIR/* /etc/wireguard/
chmod 0600 /etc/wireguard/*
EOF
}

system_run() {
    sudo ufw allow $PORT/udp
    sudo systemctl enable --now wg-quick@server
    system_status
}

system_status() {
    sudo systemctl status --now wg-quick@server
}

# docker_run() {
#     docker run -d --name wg --cap-add net_admin --cap-add sys_module -v $(pwd)/wgconf:/etc/wireguard -p $PORT:$PORT/udp cmulk/wireguard-docker:stretch
# }

# outputs private and public keys
gen_keys() {
    priv=`wg genkey`
    pub=`echo $priv | wg pubkey`
    echo $priv
    echo $pub
}

qrcode() {
    qrencode -t ANSIUTF8 < $1
}


FUNC=$1
shift

$FUNC $@
