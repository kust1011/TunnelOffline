#!/bin/bash

function _install_ziti_edge_tunnel {
    local ZITI_PATH="../binaries/ziti"
    local ZIPFILE_NAME="ziti-edge-tunnel-Linux_x86_64.zip"
    local BINARIES_NAME="ziti-edge-tunnel"

    if ! command -v $BINARIES_NAME >/dev/null 2>&1; then
        echo "$BINARIES_NAME 未安裝。正在嘗試將其複製到 /usr/local/bin。"
        # 檢查檔案是否存在於ZITI_PATH中
        if [ -f "$ZITI_PATH/$ZIPFILE_NAME" ]; then
            # 嘗試複製到/usr/local/bin
            # sudo unzip "$ZITI_PATH/$ZIPFILE_NAME" -d /usr/local/bin
            sudo unzip "$ZITI_PATH/$ZIPFILE_NAME" -d "$ZITI_PATH" > /dev/null 2>&1
            sudo install -o root -g root "$ZITI_PATH/$BINARIES_NAME" /usr/local/bin/
            sudo rm "$ZITI_PATH/$BINARIES_NAME" > /dev/null 2>&1
            # sudo chmod +x /usr/local/bin/$BINARIES_NAME  # 確保可執行權限

            if command -v "$BINARIES_NAME" >/dev/null 2>&1; then
                echo "$BINARIES_NAME 現在在 /usr/local/bin 中可用。"
            else
                echo "無法安裝 $BINARIES_NAME."
            fi
        else
            echo "$ZITI_PATH 中不存在 $ZIPFILE_NAME 的檔案。"
        fi
    else
        echo "已安裝$BINARIES_NAME"
    fi
}

function _create_POSIX_group {
    if ! grep -q '^ziti:' /etc/group; then
        echo "新增 'ziti' 群組..."
        sudo groupadd --system ziti
    # else
    #     echo "'ziti' 群組已存在"
    fi
}

function TunnelInstall {
    _install_ziti_edge_tunnel
    _create_POSIX_group
}

function Run_tunnel_service {
    local identities_path="/opt/openziti/etc/identities"
    sudo mkdir -pv $identities_path
    sudo ziti-edge-tunnel run --identity-dir $identities_path
}

# Use: Add_identities ~/Downloads/test.jwt myIdentity
# https://openziti.io/docs/reference/tunnelers/linux/#adding-identities
function Add_identities {
    if [ $# -ne 2 ]; then
        echo "Usage: add_identities [jwt path] [identity name]"
        return 1
    fi
    sudo ziti-edge-tunnel add --jwt "$(< $1)" --identity $2
}

function Remove_ziti_edge_tunnel {
    sudo rm /usr/local/bin/ziti-edge-tunnel
    sudo rm -rf /tmp/.ziti
}
