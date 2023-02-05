#!/bin/bash

###################################################################################################
#### Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
####
#### Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
#### except in compliance with the License. A copy of the License is located at
####
####     http://aws.amazon.com/apache2.0/
####
#### or in the "license" file accompanying this file. This file is distributed on an "AS IS"
#### BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#### License for the specific language governing permissions and limitations under the License.
###################################################################################################

###################################################################################################
#### This configuration file mounts an Amazon EFS file system to a directory named /efs. To mount
#### the file system to a different path, modify the MOUNT_DIRECTORY value in the "option_settings"
#### section.
####
#### The FILE_SYSTEM_ID setting references a resource named "FileSystem", which is created by the
#### storage-efs-createfilesystem.config configuration file. To use this file to mount a
#### file system that you created outside of AWS Elastic Beanstalk, replace the Ref with the
#### resource ID (e.g., fs-e7605f4e):
####
####      FILE_SYSTEM_ID: fs-e7605f4e
####
#### If your environment and file system are in a custom VPC, you must configure the VPC to allow
#### DNS resolution and DNS host names. See this topic in the VPC User Guide for more information:
####    http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html
###################################################################################################

EFS_MOUNT_DIR= "/efs"
EFS_FILE_SYSTEM_ID=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_FILE_SYSTEM_ID)
# EFS_MOUNT_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_MOUNT_DIR)
# EFS_FILE_SYSTEM_ID=$(/opt/elasticbeanstalk/bin/get-config environment -k FILE_SYSTEM_ID)

echo "Mounting EFS filesystem ${EFS_FILE_SYSTEM_ID} to directory ${EFS_MOUNT_DIR} ..."

echo 'Stopping NFS ID Mapper...'
service rpcidmapd status &> /dev/null
if [ $? -ne 0 ] ; then
    echo 'rpc.idmapd is already stopped!'
else
    service rpcidmapd stop
    if [ $? -ne 0 ] ; then
        echo 'ERROR: Failed to stop NFS ID Mapper!'
        exit 1
    fi
fi

echo 'Checking if EFS mount directory exists...'
if [ ! -d ${EFS_MOUNT_DIR} ]; then
    echo "Creating directory ${EFS_MOUNT_DIR} ..."
    mkdir -p ${EFS_MOUNT_DIR}
    if [ $? -ne 0 ]; then
        echo 'ERROR: Directory creation failed!'
        exit 1
    fi
else
    echo "Directory ${EFS_MOUNT_DIR} already exists!"
fi

mountpoint -q ${EFS_MOUNT_DIR}
if [ $? -ne 0 ]; then
    echo "mount -t efs -o tls ${EFS_FILE_SYSTEM_ID}:/ ${EFS_MOUNT_DIR}"
    mount -t efs -o tls ${EFS_FILE_SYSTEM_ID}:/ ${EFS_MOUNT_DIR}
    if [ $? -ne 0 ] ; then
        echo 'ERROR: Mount command failed!'
        exit 1
    fi
    chmod 777 ${EFS_MOUNT_DIR}
    runuser -l  ec2-user -c "touch ${EFS_MOUNT_DIR}/it_works"
    if [[ $? -ne 0 ]]; then
        echo 'ERROR: Permission Error!'
        exit 1
    else
        runuser -l  ec2-user -c "rm -f ${EFS_MOUNT_DIR}/it_works"
    fi
else
    echo "Directory ${EFS_MOUNT_DIR} is already a valid mountpoint!"
fi

echo 'EFS mount complete.'