#!/bin/bash

set -e

trap exit INT TERM

if [ -z "$DOMAINS" ]; then
  echo "DOMAINS environment variable is not set"
  exit 1;
fi

certbot certonly --non-interactive --webroot --webroot-path /var/www/certbot/ --agree-tos --register-unsafely-without-email --domains "${DOMAIN}"