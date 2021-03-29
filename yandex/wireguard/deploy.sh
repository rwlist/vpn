#!/bin/bash
# deploy.sh

WIREGUARD_HOST=$(terraform output -raw external_ip_address_vm_wireguard)

# wireguard setup
ssh yc-user@$WIREGUARD_HOST << EOF
   export SERVER_IP=$WIREGUARD_HOST
    curl https://raw.githubusercontent.com/rwlist/vpn/master/scripts/wrg.sh > wrg.sh
    chmod +x wrg.sh
    ./wrg.sh init_module
    ./wrg.sh init_files
    ./wrg.sh copy_files
    ./wrg.sh system_run
    ./wrg.sh qrcode client2.conf 
    
    echo 'client2.conf'
    cat client2.conf
    echo

    echo 'client3.conf'
    cat client3.conf
    echo

    echo 'client4.conf'
    cat client4.conf
    echo
EOF

