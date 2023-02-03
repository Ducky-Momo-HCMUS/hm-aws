#!/bin/sh

if [[ -z "$DOMAIN" ]]; then
    echo "Missing DOMAIN environment variable" 1>&2
    exit 1
fi

certbot certonly --non-interactive --webroot --webroot-path /var/www/certbot/ --agree-tos --register-unsafely-without-email --domains $DOMAIN
