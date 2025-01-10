#!/bin/bash

# 系统信息
source /etc/os-release
distro=$ID
version=$VERSION_ID

# 检测系统类型
if [ "$distro" != "alpine" ]; then
    echo "not alpine system"
    exit
fi

# 截取大版本3.16.9 => 3.16
version=$(echo $version | cut -d "." -f 1,2)

# 升级路线
# declare -A upgradeMap=(
#     ["3.16"]="3.17"
#     ["3.17"]="3.18"
#     ["3.18"]="3.19"
#     ["3.19"]="3.20"
#     ["3.20"]="3.21"
# )
# 在这里定义什么A升级到B版本
upgradeMap="3.16:3.17 3.19:3.20"
get_value() {
    key="$1"
    for pair in $upgradeMap; do
        if [ "${pair%%:*}" = "$key" ]; then
            echo "${pair##*:}"
            return
        fi
    done
    echo $1
    return
}

toversion=$(get_value $version)
if [ "$toversion" = "$version" ]; then
    echo "current $version, no need upgrade"
    exit
fi

sed -i "s/$version/$toversion/g" /etc/apk/repositories
apk update && apk add --upgrade apk-tools && apk upgrade --available && sync

echo "upgrade from $version to $toversion"
