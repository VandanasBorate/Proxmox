#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/asylumexp/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/asylumexp/Proxmox/raw/main/LICENSE
# Source: https://runtipi.io/

# App Default Values
APP="Beszel-Hub"
var_tags="os"
var_cpu="2"
var_ram="2048"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -d /opt/beszel ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    cd /opt/beszel && ./beszel update
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}${CL}"