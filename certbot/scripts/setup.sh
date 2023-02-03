#!/bin/sh

certbot certonly --non-interactive --webroot --webroot-path /var/www/certbot/ --domains $DOMAIN --agree-tos --register-unsafely-without-email
