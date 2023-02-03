FROM certbot/certbot:latest

WORKDIR /app

COPY scripts scripts
RUN chmod +x scripts/setup.sh

ENTRYPOINT [ "scripts/setup.sh" ]