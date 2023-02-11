#!/bin/bash

load_nginx_config() {
    app_path="/var/app/current"
    config_path="$app_path/nginx/configs"

    # Use "\" to override alias
    \cp --verbose -R $config_path/. "/etc/nginx/"
}

load_nginx_config
systemctl start nginx
