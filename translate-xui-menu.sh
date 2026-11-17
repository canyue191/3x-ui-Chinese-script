#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
plain='\033[0m'

translate_xui_menu() {
    local file="$1"
    [[ -f "$file" ]] || return 1

    sed -i \
        -e '/^show_menu() {/,/^}/ s/3X-UI Panel Management Script/3X-UI 面板管理脚本/g' \
        -e '/^show_menu() {/,/^}/ s/Exit Script/退出脚本/g' \
        -e '/^show_menu() {/,/^}/ s/Update to Dev Channel (latest commit)/更新到开发版（最新提交）/g' \
        -e '/^show_menu() {/,/^}/ s/Update Menu/更新菜单/g' \
        -e '/^show_menu() {/,/^}/ s/Legacy Version/旧版安装/g' \
        -e '/^show_menu() {/,/^}/ s/Reset Username & Password/重置用户名和密码/g' \
        -e '/^show_menu() {/,/^}/ s/Reset Web Base Path/重置面板路径/g' \
        -e '/^show_menu() {/,/^}/ s/Reset Settings/重置设置/g' \
        -e '/^show_menu() {/,/^}/ s/Change Port/修改端口/g' \
        -e '/^show_menu() {/,/^}/ s/View Current Settings/查看当前设置/g' \
        -e '/^show_menu() {/,/^}/ s/Restart Xray/重启 Xray/g' \
        -e '/^show_menu() {/,/^}/ s/Logs Management/日志管理/g' \
        -e '/^show_menu() {/,/^}/ s/Enable Autostart/启用开机自启/g' \
        -e '/^show_menu() {/,/^}/ s/Disable Autostart/关闭开机自启/g' \
        -e '/^show_menu() {/,/^}/ s/SSL Certificate Management/SSL 证书管理/g' \
        -e '/^show_menu() {/,/^}/ s/Cloudflare SSL Certificate/Cloudflare SSL 证书/g' \
        -e '/^show_menu() {/,/^}/ s/IP Limit Management/IP 限制管理/g' \
        -e '/^show_menu() {/,/^}/ s/Firewall Management/防火墙管理/g' \
        -e '/^show_menu() {/,/^}/ s/SSH Port Forwarding Management/SSH 端口转发管理/g' \
        -e '/^show_menu() {/,/^}/ s/PostgreSQL Management/PostgreSQL 管理/g' \
        -e '/^show_menu() {/,/^}/ s/Enable BBR/启用 BBR/g' \
        -e '/^show_menu() {/,/^}/ s/Update Geo Files/更新 Geo 文件/g' \
        -e '/^show_menu() {/,/^}/ s/Speedtest by Ookla/Ookla 网速测试/g' \
        -e '/^show_menu() {/,/^}/ s/Please enter your selection/请输入选项/g' \
        -e '/^show_menu() {/,/^}/ s/Install/安装/g' \
        -e '/^show_menu() {/,/^}/ s/Update/更新/g' \
        -e '/^show_menu() {/,/^}/ s/Uninstall/卸载/g' \
        -e '/^show_menu() {/,/^}/ s/Start/启动/g' \
        -e '/^show_menu() {/,/^}/ s/Stop/停止/g' \
        -e '/^show_menu() {/,/^}/ s/Restart/重启/g' \
        -e '/^show_menu() {/,/^}/ s/Check Status/查看状态/g' \
        -e '/^show_status() {/,/^}/ s/Panel state:/面板状态：/g' \
        -e '/^show_status() {/,/^}/ s/Not Running/未运行/g' \
        -e '/^show_status() {/,/^}/ s/Not Installed/未安装/g' \
        -e '/^show_status() {/,/^}/ s/Running/运行中/g' \
        -e '/^show_enable_status() {/,/^}/ s/Start automatically:/开机自启：/g' \
        -e '/^show_enable_status() {/,/^}/ s/Managed by Docker/由 Docker 管理/g' \
        -e '/^show_enable_status() {/,/^}/ s/Yes/是/g' \
        -e '/^show_enable_status() {/,/^}/ s/No/否/g' \
        -e '/^show_xray_status() {/,/^}/ s/xray state:/Xray 状态：/g' \
        -e '/^show_xray_status() {/,/^}/ s/Not Running/未运行/g' \
        -e '/^show_xray_status() {/,/^}/ s/Running/运行中/g' \
        -e '/^show_mtproto_status() {/,/^}/ s/mtproto inbound/MTProto 入站/g' \
        -e '/^show_mtproto_status() {/,/^}/ s/Not Running/未运行/g' \
        -e '/^show_mtproto_status() {/,/^}/ s/Running/运行中/g' \
        "$file"
}

if [[ $EUID -ne 0 ]]; then
    echo -e "${red}请使用 root 权限运行此脚本。${plain}" >&2
    exit 1
fi

installed_script="/usr/bin/x-ui"
if [[ ! -s "${installed_script}" ]]; then
    echo -e "${red}未找到 ${installed_script}，请先安装 3X-UI。${plain}" >&2
    exit 1
fi

temp_file="${installed_script}.menu-temp.$$"
trap 'rm -f "${temp_file}"' EXIT
if ! cp -p "${installed_script}" "${temp_file}" || ! translate_xui_menu "${temp_file}"; then
    echo -e "${red}更新 x-ui 菜单失败。${plain}" >&2
    exit 1
fi
chmod +x "${temp_file}" || exit 1
mv -f "${temp_file}" "${installed_script}" || exit 1
trap - EXIT
echo -e "${green}管理菜单已切换为中文，请重新运行 x-ui。${plain}"
