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
}

function clear_redhat() {
    if [ "$distro" != "centos" ] && [ "$distro" != "fedora" ]; then
        return
    fi

    yum clean all
    rm -rf /var/cache/yum
}

clear_alpine
clear_debian
clear_redhat
