FROM nginx:stable-alpine

EXPOSE 80

COPY configs /etc/nginx
COPY scripts/setup.sh /opt/

RUN chmod +x /opt/setup.sh \
    && apk add --no-cache bash certbot certbot-nginx \
    # Delete the default welcome to nginx page.
    && rm /usr/share/nginx/html/*

ENTRYPOINT ["/opt/setup.sh"]