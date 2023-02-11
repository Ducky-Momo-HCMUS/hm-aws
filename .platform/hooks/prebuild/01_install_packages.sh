#!/bin/bash

install_package() {
  package=$1
  echo "Installing $package"
  yum install -y -q "$package"
  echo "Finished installing $package"
}

install_package amazon-efs-utils
install_package certbot
install_package certbot-nginx