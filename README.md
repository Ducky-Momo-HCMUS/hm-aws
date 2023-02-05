## Stack

### Elastic Beanstalk with Docker Compose

The Docker platform (Amazon Linux 2) with Docker Compose doesn't setup NGINX (see [here]((https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-specific.html#command-options-docker))) so we have to setup our own, either:

1. Config and enable NGINX manually on host machine. We can also install [certbot](https://certbot.eff.org) for automatic SSL configuration.
2. Use [NGINX image](https://hub.docker.com/_/nginx). **_(current approach)_**

We packed all services and BFF into one instance environment to reduce cost to a minimum. A real production scenario should have each service in a separate environment (and behind a load balancer, too).

### EFS

Persistent storage for EC2. Can be used to store certificates or private files.

**Important**: Both EFS and EC2 must be on the same security group. You can configure it with 

    EB Console -> Configuration -> Instances -> EC2 security groups

EFS is mounted via `03_mount_efs.sh`. For more information, see [here](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/services-efs.html#services-efs-configs).

### NGINX

Serve as reverse proxy server for the backend services, it also do SSL termination, and response compression (gzip).

The `nginx.conf` is copied from Elastic Beanstalk template to enable health checking and logging.

### ZeroSSL

Initially, SSL certificates for NGINX are generated using certbot. But we cannot utilize EC2 to store certificates because it is a disposable platform. A workaround is to setup S3 backup using shell scripts or mount an EFS.

Another alternative is ZeroSSL.

### CircleCI

## Configuration 

Important checklist for EB, based on AWS console. Options not listed here are set as default or not important to the application.

### Software

#### Container options

- Proxy server: None (NGINX is not available in docker compose environment)

#### Environment properties

Copy and paste your `.env` file here

### Instances

#### EC2 security groups

Add EFS security group here.

### Security

#### Virtual machine permissions

- EC2 key pair: For debug purposes. Allow you to tunnel to EC2 instance. 

### Network

Add your prefered "Instance subnets" and "Database subnets"

### Database

TODO