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

echo "Installing ZeroSSL certificates"
cat /etc/ssl/zerossl/certificate.crt /etc/ssl/zerossl/ca_bundle.crt >>/etc/ssl/zerossl/nginx.crt
echo "Certificates installed"

nginx -g "daemon off;"
