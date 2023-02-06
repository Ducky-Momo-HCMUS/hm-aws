#!/bin/bash

echo 'export EFS_ID="fs-0fd3fd850a9d21c1a"' >> ~/.bashrc
echo 'export EFS_MOUNT_DIR="/efs"' >> ~/.bashrc
echo 'export EFS_DOMAIN_SSL_DIR="${EFS_MOUNT_DIR}/ssl/${DOMAIN}"' >> ~/.bashrc

echo 'export EC2_SSL_DIR="/etc/ssl/letsencrypt"' >> ~/.bashrc

cat ~/.bashrc
