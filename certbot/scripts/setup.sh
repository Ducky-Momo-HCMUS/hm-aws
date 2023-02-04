#!/bin/bash

set -e

trap exit INT TERM

if [[ -z "$DOMAIN" ]]; then
  echo "DOMAIN environment variable is not set"
  exit 1;
fi

fullchain_path=/etc/letsencrypt/live/"$DOMAIN"/fullchain.pem;
privkey_path=/etc/letsencrypt/live/"$DOMAIN"/privkey.pem;

if [[ -f "$fullchain_path" && -f "$privkey_path" ]]; then
  certbot certonly --non-interactive --standalone --agree-tos --register-unsafely-without-email --domains "${DOMAIN}"
else
  certbot certonly --non-interactive --webroot --webroot-path /var/www/certbot/ --agree-tos --register-unsafely-without-email --domains "${DOMAIN}"
fi  
