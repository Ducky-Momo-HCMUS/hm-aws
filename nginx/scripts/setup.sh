#!/bin/bash

set -e

trap exit INT TERM

check_env() {
  if [[ -z "${!1}" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

check_env DOMAIN
check_env EC2_BASE_CERTBOT_DIR
check_env EFS_BASE_SSL_DIR

# https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates
# both "ssl_dir" and "certbot_ssl_dir" should already be populated by "05_sync_with_efs.sh"

cerbot_ssl_dir="$EC2_BASE_CERTBOT_DIR/live/$DOMAIN"
certbot_fullchain_path="$cerbot_ssl_dir/fullchain.pem"
certbot_privkey_path="$cerbot_ssl_dir/privkey.pem"

echo "$certbot_fullchain_path"
echo "$certbot_privkey_path"

ssl_dir="$EC2_SSL_DIR/live"
fullchain_path="$ssl_dir/fullchain.pem"
privkey_path="$ssl_dir/privkey.pem"

# certbot --nginx \
#         --non-interactive \
#         --agree-tos \
#         --register-unsafely-without-email \
#         --domains "$DOMAIN"

# certbot renewal -> changes in files -> copy all back to EFS
if [ -s "$certbot_fullchain_path" ] && cmp --silent -- "$certbot_fullchain_path" "$fullchain_path" || \ 
   [ -s "$certbot_privkey_path" ] && cmp --silent -- "$certbot_privkey_path" "$privkey_path" 
then
  echo "Change found in certificates, syncing to $EFS_BASE_SSL_DIR"
  rsync -a --delete "$EC2_BASE_CERTBOT_DIR/live/$DOMAIN" "$EC2_SSL_DIR/live"
  rsync -a --delete "$EC2_BASE_CERTBOT_DIR/archive/$DOMAIN" "$EC2_SSL_DIR/archive"
  rsync -a --delete "$EC2_BASE_CERTBOT_DIR/keys/$DOMAIN" "$EC2_SSL_DIR/keys"

  rsync -a --delete "$EC2_SSL_DIR" "$EFS_BASE_SSL_DIR/$DOMAIN"
else
  echo "No change found, do nothing"
fi

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
