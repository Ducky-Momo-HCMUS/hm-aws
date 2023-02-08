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
check_env EC2_CERTBOT_DIR
check_env EC2_CERTBOT_BACKUP_DIR
check_env EFS_BASE_CERTBOT_DIR

# https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates
# both "ssl_dir" and "backup_ssl_dir" should already be populated by "05_sync_with_efs.sh"

backup_ssl_dir="$EC2_CERTBOT_BACKUP_DIR/live/$DOMAIN"
mkdir -p "$backup_ssl_dir"
backup_fullchain_path="$backup_ssl_dir/fullchain.pem"
backup_privkey_path="$backup_ssl_dir/privkey.pem"

ssl_dir="/etc/letsencrypt/live/$DOMAIN"
fullchain_path="$ssl_dir/fullchain.pem"
privkey_path="$ssl_dir/privkey.pem"

echo "$fullchain_path"
echo "$privkey_path"

if [[ ! -f "$fullchain_path" ]] || [[ ! -f "$privkey_path" ]]; then
  echo "Certificates not found. Generating dummies for Nginx startup"
  mkdir -p "$ssl_dir"
  openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -subj "/CN=localhost" \
    -keyout "$privkey_path" \
    -out "$fullchain_path"
else
  echo "Certificates already exists. Do nothing"
fi

# certbot renewal -> changes in files -> copy all back to EFS
# if [ -s "$certbot_fullchain_path" ] && cmp -s -- "$certbot_fullchain_path" "$fullchain_path" || \ 
#    [ -s "$certbot_privkey_path" ] && cmp -s -- "$certbot_privkey_path" "$privkey_path" 
# then
#   echo "Change found in certificates, syncing to $EFS_BASE_CERTBOT_DIR"
#   rsync -a --delete "$EC2_CERTBOT_DIR/live/$DOMAIN" "$EC2_CERTBOT_BACKUP_DIR/live"
#   rsync -a --delete "$EC2_CERTBOT_DIR/archive/$DOMAIN" "$EC2_CERTBOT_BACKUP_DIR/archive"
#   rsync -a --delete "$EC2_CERTBOT_DIR/keys/$DOMAIN" "$EC2_CERTBOT_BACKUP_DIR/keys"

#   rsync -a --delete "$EC2_CERTBOT_BACKUP_DIR" "$EFS_BASE_CERTBOT_DIR/$DOMAIN"
# else
#   echo "No change found, do nothing"
# fi

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
