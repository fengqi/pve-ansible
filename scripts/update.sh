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
    alpine)
        echo "更新 Alpine 系统"
        apk update && apk upgrade
        #apk cache clean # Package cache is not enabled.
        ;;
    ubuntu|debian)
        echo "更新 Debian/Ubuntu 系统"
        apt-get update && apt-get dist-upgrade -y
        apt-get autoremove -y && apt-get clean
        ;;
    arch)
        echo "更新 Arch 系统"
        pacman -Syu --noconfirm
        pacman -Sc --noconfirm
        ;;
    *)
        echo "不支持的发行版: $distro"
        exit 1
        ;;
esac

