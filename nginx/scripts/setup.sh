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

crt_path="/etc/ssl/zerossl/nginx.crt"

if [ -f "$crt_path" ]; then
  echo "Certificates already exist"
else
  echo "Installing ZeroSSL certificates"
  cat /etc/ssl/zerossl/certificate.crt /etc/ssl/zerossl/ca_bundle.crt >> $crt_path
  echo "Certificates installed"
fi

nginx -g "daemon off;"
