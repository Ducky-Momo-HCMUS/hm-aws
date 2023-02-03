FROM certbot/certbot:latest

COPY scripts /scripts
RUN chmod +x /scripts/setup.sh

CMD ["/bin/sh", "/scripts/setup.sh"]
