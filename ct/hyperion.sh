#!/usr/bin/env bash
source ./misc/build.func
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://hyperion-project.org/forum/

# App Default Values
APP="Hyperion"
var_tags="ambient-lightning"
var_cpu="1"
var_ram="512"
var_disk="2"
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
      if [[ ! -f /etc/apt/sources.list.d/hyperion.list ]]; then
            msg_error "No ${APP} Installation Found!"
            exit
      fi
      msg_info "Updating ${APP} LXC"
      apt-get update &>/dev/null
      apt-get install -y hyperion &>/dev/null
      msg_ok "Updated Successfully"
      exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8090${CL}"