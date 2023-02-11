#!/bin/bash

install_package() {
  package=$1
  echo "Installing $package"
  yum install -y -q "$package"
  echo "Finished installing $package"
}

yum update

install_package amazon-efs-utils
amazon-linux-extras install epel
install_package certbot
install_package certbot-nginx