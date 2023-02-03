FROM certbot/certbot:latest

COPY scripts /scripts
RUN chmod +x /scripts/setup.sh

# https://stackoverflow.com/a/56791772/12405558
ENTRYPOINT ["sh", "/scripts/setup.sh"]
