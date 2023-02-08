FROM nginx:stable-alpine

EXPOSE 80

COPY configs /etc/nginx
COPY ssl-dhparams.pem /opt/certbot/
COPY scripts/setup.sh /opt/nginx/

RUN chmod +x /opt/nginx/setup.sh \
    && apk add --quiet --no-cache bash openssl \
    # Delete the default welcome to nginx page.
    && rm /usr/share/nginx/html/*

# Start nginx in the foreground to play nicely with Docker.
CMD ["nginx", "-g", "daemon off;"]

# ENTRYPOINT ["/opt/nginx/setup.sh"]