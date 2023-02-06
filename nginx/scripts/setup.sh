#!/bin/bash

set -e

trap exit INT TERM

fullchain_path="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
privkey_path="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

echo "$fullchain_path"
echo "$privkey_path"

# certbot --nginx --non-interactive --agree-tos --register-unsafely-without-email --domains "$DOMAIN"
nginx -g "daemon off;"

# if [[ -f "$fullchain_path" && -f "$privkey_path" ]]; then
#   echo "Certificates not found. Executing certbot --nginx"
#   certbot --nginx --non-interactive --standalone --agree-tos --register-unsafely-without-email --domains "${DOMAIN}"
#   nginx -g "daemon off;"
# else
#   echo "File found"
#   nginx -g "daemon off;"
#   certbot certonly --non-interactive --webroot --webroot-path /var/www/certbot/ --agree-tos --register-unsafely-without-email --domains "${DOMAIN}"
# fi
