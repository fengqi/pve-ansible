#!/sbin/openrc-run

name=$RC_SVCNAME
command=/opt/memos/memos
command_args="${SYNCTHING_ARGS:---addr 0.0.0.0 --port 80 --mode prod --data /opt/memos}"
command_user="${SYNCTHING_USER:-root}"
pidfile=/run/${RC_SVCNAME}.pid
command_background=yes
start_stop_daemon_args="-d /opt/memos -1 /var/log/${RC_SVCNAME}.log -2 /var/log/${RC_SVCNAME}.log"

depend() {
    use logger dns
    need net
    after firewall
}

start_pre() {
    > /var/log/${RC_SVCNAME}.log
}