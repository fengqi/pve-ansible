#!/sbin/openrc-run

name=$RC_SVCNAME
command=/opt/bark/bark
command_args="${SYNCTHING_ARGS:---addr 0.0.0.0:80 --data /opt/bark/data}"
command_user="${SYNCTHING_USER:-root}"
pidfile=/run/${RC_SVCNAME}.pid
command_background=yes
start_stop_daemon_args="-d /opt/bark -1 /var/log/${RC_SVCNAME}.log -2 /var/log/${RC_SVCNAME}.log"

depend() {
    use logger dns
    need net
    after firewall
}

start_pre() {
    chmod +x /opt/bark/bark
    setcap CAP_NET_BIND_SERVICE=+eip /opt/bark/bark
    > /var/log/${RC_SVCNAME}.log
}