#!/bin/bash

check_env() {
  if [[ -z "${!1}" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

check_env DOMAIN

certbot --nginx --test-cert --agree-tos --register-unsafely-without-email --domains "$DOMAIN"
