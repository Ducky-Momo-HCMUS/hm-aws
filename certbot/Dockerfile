FROM certbot/certbot:latest

RUN apk add --no-cache bash
COPY scripts /scripts
RUN chmod +x /scripts/setup.sh

ENTRYPOINT ["/scripts/setup.sh"]
