#!/bin/bash

# 检测系统类型
if [ -f /etc/os-release ]; then
    source /etc/os-release
    distro=$ID
else
    echo "无法识别系统类型"
    exit 1
fi

command -v journalctl > /dev/null && journalctl --vacuum-size=50M || true
find /var/log -name "*.gz" -exec rm -rf {} \;
find /var/log -name "*.[0-9]" -exec rm -rf {} \;

function clear_alpine() {
    if [ "$distro" != "alpine" ]; then
        return
    fi

    apk cache clean
    rm -rf /var/cache/apk/*
}

function clear_debian() {
    if [ "$distro" != "ubuntu" ] && [ "$distro" != "debian" ]; then
        return
    fi

    apt-get autoremove -y
    for i in `dpkg -l | grep ^rc |awk '{print $2}'`;do dpkg -P $i;done
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    rm -rf rm -f /var/lib/dpkg/available-old
    rm -rf rm -f /var/lib/dpkg/diversions-old
}

function clear_redhat() {
    if [ "$distro" != "centos" ] && [ "$distro" != "fedora" ]; then
        return
    fi

    yum clean all
    rm -rf /var/cache/yum
}

function clrar_samba_log() {
    if [ ! -d "/var/log/samba" ]; then
        return
    fi

    rm -rf /var/log/samba/*
}

function clear_frp_log() {
    rm -rf /var/log/frps.202*
    rm -rf /var/log/frpc.202*
}

function clear_docker_log() {
    rm -rf /var/log/docker.log.*
}

function clear_nginx_log() {
    rm -rf /var/log/nginx/access.log.*
    rm -rf /var/log/nginx/error.log.*
    rm -rf /var/log/nginx/*.log-*
}

function clear_php_log() {
    rm -rf /var/log/php/errors.log.*
    rm -rf /var/log/*/*.log-*
}

function show_log_list() {
    command -v tree > /dev/null && tree -L 2 /var/log || ls /var/log
}

clear_alpine
clear_debian
clear_redhat
clear_frp_log
clear_samba_log
clear_docker_log
clear_nginx_log
clear_php_log
show_log_list