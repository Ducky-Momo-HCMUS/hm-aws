FROM nginx:stable-alpine

EXPOSE 80

COPY configs /etc/nginx
COPY scripts/setup.sh /opt/nginx/
# ZeroSSL domain verification
COPY zerossl /var/www/zerossl

RUN chmod +x /opt/nginx/setup.sh \
    && apk add --no-cache bash \
    # Delete the default welcome to nginx page.
    && rm /usr/share/nginx/html/*

# Start nginx in the foreground to play nicely with Docker.
CMD ["nginx", "-g", "daemon off;"]

# ENTRYPOINT ["/opt/setup.sh"]