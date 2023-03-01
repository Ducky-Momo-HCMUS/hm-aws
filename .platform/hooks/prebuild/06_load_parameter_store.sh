#!/bin/bash

OUT_DIR="/etc/hm-secrets"

load_parameter() {
  key=$1
  target=$2

  echo "Loading $key from parameter store"
  aws ssm get-parameter --name "$key" \
                        --with-decryption \
                        --output text \
                        --query Parameter.Value > "$OUT_DIR/$target"
  echo "Saved $key to $target"
}

mkdir -p $OUT_DIR
load_parameter "hm-auth-priv-key" "private.key"
load_parameter "hm-auth-pub-key" "public.pem"