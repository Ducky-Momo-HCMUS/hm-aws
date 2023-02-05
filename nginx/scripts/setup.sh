#!/bin/bash

set -e

trap exit INT TERM

if [[ -z "$ZEROSSL_ID" ]]; then
  echo "ZEROSSL_ID environment variable is not set"
  exit 1
fi

if [[ -z "$ZEROSSL_ACCESS_KEY" ]]; then
  echo "ZEROSSL_ACCESS_KEY environment variable is not set"
  exit 1
fi

unzip_zerossl() {
  api=https://api.zerossl.com/certificates/"$ZEROSSL_ID"/download?access_key="$ZEROSSL_ACCESS_KEY"
  # Download and unzip certificates
  cd /opt/nginx                        && \
  curl --show-error "$api" > certs.zip && \
  unzip certs.zip                      && \
  rm certs.zip
}

echo "$fullchain_path"
echo "$privkey_path"

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
