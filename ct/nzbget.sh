#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/asylumexp/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck | Co-Author: havardthom
# License: MIT | https://github.com/asylumexp/Proxmox/raw/main/LICENSE
# Source: https://nzbget.com/

# App Default Values
APP="NZBGet"
var_tags="usenet;downloader"
var_cpu="2"
var_ram="2048"
var_disk="4"
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
    if [[ ! -f /lib/systemd/system/nzbget.service ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Updating $APP LXC"
    apt-get update &>/dev/null
    apt-get -y upgrade &>/dev/null
    msg_ok "Updated $APP LXC"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:6789${CL}"