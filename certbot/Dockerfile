FROM certbot/certbot:v1.29.0

RUN apk add --no-cache bash
COPY scripts/setup.sh /opt/
RUN chmod +x /opt/setup.sh

ENTRYPOINT ["/opt/setup.sh"]
