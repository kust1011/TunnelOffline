# Ziti Edge Tunnel 離線安裝指南

本腳本用於安裝和管理 Ziti Edge Tunnel。
Ziti Edge Tunnel 允許設備安全地訪問 Ziti 網路提供的服務。

## 前置條件：
- Linux 系統 (x86_64)
- `sudo` 權限
- `unzip` 和 `grep` 工具應已安裝

## 安裝：

按照以下步驟設置 OpenZiti：

1. 下載專案
```bash
    git clone https://github.com/kust1011/TunnelOffline.git
```
2. 導航到腳本目錄
```bash
    cd TunnelOffline/scripts
```
3. 執行主安裝腳本
```bash
    . main_install.sh
    TunnelInstall
```
4. 運行 Ziti Edge Tunnel 服務
```bash
    Run_tunnel_service
```
5. 添加身份證明 (在另一個終端執行)

```bash
    # 請先導航到腳本目錄
    . main_install.sh
    Add_identities /path/to/your/jwt/file.jwt yourIdentityName
```

    或是直接：

```bash
    ziti-edge-tunnel add --jwt "$(< /path/to/your/jwt/file.jwt)" --identity yourIdentityName
```  

6. 移除 Ziti Edge Tunnel

    如需移除 Ziti Edge Tunnel，可以執行：
```bash
    Remove_ziti_edge_tunnel
```
