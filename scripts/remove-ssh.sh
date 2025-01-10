#!/bin/bash

# 检测系统类型
if [ -f /etc/os-release ]; then
    source /etc/os-release
    distro=$ID
else
    echo "无法识别系统类型"
    exit 1
fi

# 根据发行版执行更新
case $distro in
    ubuntu|debian)
        apt-get remove -y openssh-client openssh-server openssh-sftp-server
        dpkg -P openssh-client openssh-server
        apt-get autoremove -y
        apt-get clean
        ;;
    arch)
        pacman -Rs --noconfirm openssh
        pacman -Sc --noconfirm
        ;;
    *)
        echo "不支持的发行版: $distro"
        exit 1
        ;;
esac
