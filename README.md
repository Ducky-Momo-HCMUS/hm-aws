# HM-AWS

Elastic beanstalk deployment config for Homeroom management. Other services such as *hm-service* and *hm-web* will pull this repository and perform deployment on CircleCI.

## Stack

### Elastic Beanstalk with Docker Compose

The Docker platform (Amazon Linux 2) with Docker Compose doesn't setup NGINX (see [here](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-specific.html#command-options-docker)) so we have to setup our own, either:

1. Config and enable NGINX manually on host machine. We can also install [certbot](https://certbot.eff.org) for automatic SSL configuration. **_(current approach)_**
2. Use [NGINX image](https://hub.docker.com/_/nginx).

We packed all services and BFF into one instance environment to reduce cost to a minimum. A real production scenario should have each service in a separate environment (and behind a load balancer, too).

### EFS

Persistent storage for EC2. Can be used to store certificates or private files.

**Important**: Both EFS and EC2 must be on the same security group. You can configure it with

    EB Console -> Configuration -> Instances -> EC2 security groups

EFS is mounted via `03_mount_efs.sh`. For more information, see [here](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/services-efs.html#services-efs-configs).

### NGINX

Serve as reverse proxy server for the backend services, it also do SSL termination, and response compression (gzip).

The `nginx.conf` is copied from Elastic Beanstalk template to enable health checking and logging.

### Parameter Store

Store secret files such as private key use for signing JWT token

## Configuration

Important checklist for EB, based on [AWS console](https://ap-southeast-1.console.aws.amazon.com/elasticbeanstalk/home). Options aren't listed here are set as default or are not important to the application.

- Software
  - Container options
    - Proxy server: None (NGINX is not available in docker compose environment, so "Nginx" option is useless)
  - Environment properties: Copy and paste your `.env` file here. Additional variables:
    - DOCKER_REGISTRY
    - DOMAIN
    - EFS_FILE_SYSTEM_ID
- Instances
  - EC2 security groups: Add EFS security group here.
- Security
  - Virtual machine permissions
    - EC2 key pair: For debug purposes. Allow you to tunnel to EC2 instance
- Network: Add your prefered "Instance subnets" and "Database subnets"
- Database: You should use a separate database on RDS and connect it with environment properties

## Secrets

Secret are store as environment variables in EB configuration or files on EFS such as SSL certificates. Here are required env and files:

Environment variables:

- `DOCKER_REGISTRY`
- `DOMAIN`
- `EFS_FILE_SYSTEM_ID`

## Permissions

Some extra permissions are required:

- [AmazonEC2ContainerRegistryReadOnly](https://docs.aws.amazon.com/AmazonECR/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEC2ContainerRegistryReadOnly): Allow EB to pull images from ECR.
- [AmazonSSMReadOnlyAccess](https://docs.aws.amazon.com/systems-manager/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonSSMReadOnlyAccess): Load secrets from parameter store.

## Deployment

Assume that: 

1. Elastic Beanstalk is set up and running (for example the EB name will be "hm-env")
2. You have deployed *hm-service* and apps/server in *hm-web* to ECR or DockerHub

When you execute `eb deploy hm-env`, the following will happen on Elastic Beanstalk:

1. Push *hm-aws* to S3
2. Pull from S3 to EC2
3. Execute scripts in *.platform/hooks/prebuild*
4. Execute `docker-compose.yaml`
5. Execute scripts in *.platform/hooks/postdeploy*
