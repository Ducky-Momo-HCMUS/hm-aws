FROM nginx:stable-alpine

EXPOSE 80

COPY configs /etc/nginx
COPY scripts/setup.sh /opt/nginx/
COPY ssl-dhparams.pem /etc/letsencrypt

RUN chmod +x /opt/nginx/setup.sh \
    && apk add --quiet --no-cache bash certbot certbot-nginx \
    # Delete the default welcome to nginx page.
    && rm /usr/share/nginx/html/*

# # Start nginx in the foreground to play nicely with Docker.
# CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["/opt/nginx/setup.sh"]