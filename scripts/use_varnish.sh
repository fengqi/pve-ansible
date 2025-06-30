#!/bin/sh

source /etc/os-release
distro=$ID
version=$VERSION_ID
codename=$VERSION_CODENAME

# alpine
if [ "$distro" = "alpine" ]; then
    grep -q 'varnish.fengqi.io' /etc/apk/repositories
    if [ $? -eq 0 ]; then
        exit 0
    fi

    version=$(echo $version | cut -d '.' -f 1-2)

    echo "http://varnish.fengqi.io/alpine/v${version}/main" > /etc/apk/repositories
    echo "http://varnish.fengqi.io/alpine/v${version}/community" >> /etc/apk/repositories

    apk update
    exit 0
fi

# debian
if [ "$distro" = "debian" ]; then
    grep -q 'varnish.fengqi.io' /etc/apt/sources.list
    if [ $? -eq 0 ]; then
        exit 0
    fi

    if [ -f /etc/apt/sources.list ]; then
        echo "deb http://varnish.fengqi.io/debian ${codename} main contrib" > /etc/apt/sources.list
        echo "deb http://varnish.fengqi.io/debian ${codename}-updates main contrib" >> /etc/apt/sources.list
        echo "deb http://varnish.fengqi.io/debian-security ${codename}-security main contrib" >> /etc/apt/sources.list
    fi

    grep -q 'varnish.fengqi.io' /etc/apt/sources.list.d/debian.sources
    if [ $? -eq 0 ]; then
        exit 0
    fi

    if [ -f /etc/apt/sources.list.d/debian.sources ]; then
        grep -q "testing" /etc/apt/sources.list.d/debian.sources
        if [ $? -eq 0 ]; then
            codename="testing"
        fi

        cat > /etc/apt/sources.list.d/debian.sources <<EOF
Types: deb
URIs: http://varnish.fengqi.io/debian/
Suites: ${codename} ${codename}-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://varnish.fengqi.io/debian/
Suites: ${codename}-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://varnish.fengqi.io/debian-security/
Suites: ${codename}-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
    fi

    apt-get update
    exit 0
fi

# ubuntu
if [ "$distro" = "ubuntu" ]; then
    grep -q 'varnish.fengqi.io' /etc/apt/sources.list
    if [ $? -eq 0 ]; then
        exit 0
    fi

    echo "deb http://varnish.fengqi.io/ubuntu ${codename} main restricted universe multiverse" > /etc/apt/sources.list
    echo "deb http://varnish.fengqi.io/ubuntu ${codename}-updates main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb http://varnish.fengqi.io/ubuntu ${codename}-security main restricted universe multiverse" >> /etc/apt/sources.list
    apt-get update
    exit 0
fi
