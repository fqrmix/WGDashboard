#!/bin/bash

echo $WGDASHBOARD_CUSTOM_CONFIG
if [[ $WGDASHBOARD_CUSTOM_CONFIG != "" ]]; then
    echo "Custom config is set. Copying wg-dashboard.ini file"
    cp /home/app/wg-dashboard.ini /home/app/src/
fi

if [[ $WG_CONF_FOLDER_PATH == "" ]]; then 
    wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
    # set temp envs
    export SERVER_PRIVATE_KEY=$(cat /etc/wireguard/privatekey)
    # sub in vars in template .conf
    envsubst < /home/app/wg0_template.conf > /etc/wireguard/wg0.conf 
    # chmod
    chmod 600 /etc/wireguard/{privatekey,wg0.conf}

else
    echo "Custom WG config folder is set. Copying *.conf files into /etc/wireguard"
    config_files=$(find /home/app/config -type f -name "*.conf")
    for file in $config_files; do
        echo "$file"
        cp $file /etc/wireguard
    done
fi



run_wireguard_up() {
  config_files=$(find /etc/wireguard -type f -name "*.conf")
  
  for file in $config_files; do
    config_name=$(basename "$file" ".conf")
    chmod 600 "/etc/wireguard/$config_name.conf"
    echo "Starting up $config_name WG interface..."
    wg-quick up "$config_name" #> /dev/null 2>&1
  done
}

run_wireguard_up
