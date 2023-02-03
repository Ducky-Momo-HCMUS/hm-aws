FROM certbot/certbot:latest

COPY scripts scripts
RUN chmod +x scripts/setup.sh

ENTRYPOINT [ "../scripts/setup.sh" ]