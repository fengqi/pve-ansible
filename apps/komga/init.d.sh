#!/sbin/openrc-run

name=$RC_SVCNAME
command=/usr/bin/java
command_args="${SYNCTHING_ARGS:---enable-preview --enable-native-access=ALL-UNNAMED -jar -Xmx1g komga.jar}"
command_user="${SYNCTHING_USER:-root}"
pidfile=/run/${RC_SVCNAME}.pid
command_background=yes
start_stop_daemon_args="-d /opt/komga -1 /var/log/${RC_SVCNAME}.log -2 /var/log/${RC_SVCNAME}.log"

depend() {
    use logger dns
    need net
    after firewall
}
