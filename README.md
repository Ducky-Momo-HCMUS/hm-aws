## Stack

### Elastic Beanstalk with Docker Compose

The Docker platform (Amazon Linux 2) with Docker Compose doesn't setup NGINX (see [here]((https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-specific.html#command-options-docker))) so we have to setup our own, either:

1. Config and enable NGINX manually on host machine. We can also install [certbot](https://certbot.eff.org) for automatic SSL configuration.
2. Use [NGINX image](https://hub.docker.com/_/nginx). **_(current approach)_**

We packed all services and BFF into one instance environment to reduce cost to a minimum. A real production scenario should have each service in a separate environment (and behind a load balancer, too).

### NGINX

Serve as reverse proxy server for the backend services, it also do SSL termination, and response compression (gzip).

The `nginx.conf` is copied from Elastic Beanstalk template to enable health checking and logging.

### ZeroSSL

Initially, SSL certificates for NGINX are generated using certbot. But we cannot utilize EC2 to store certificates because it is a disposable platform. A workaround is to setup S3 backup using shell scripts or mount an EFS.

Another alternative is ZeroSSL.

### CircleCI
