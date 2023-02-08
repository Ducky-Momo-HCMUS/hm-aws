#!/bin/bash

nginx_name="current_nginx_1"
certbot_name="current_certbot_1"

# Reload nginx to apply certbot certificates
echo "Waiting for certbot to finish"
until [ "$( docker inspect -f {{.State.Status}} $certbot_name )"=="exited" ]; do
    sleep 5;
done;

# echo "Certbot has exited. Reloading nginx"
# docker exec $nginx_name nginx -s reload
# echo "Finished reloading nginx"