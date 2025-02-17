#!/sbin/openrc-run

name=$RC_SVCNAME
command=/opt/bitwarden/vaultwarden
command_args="${SYNCTHING_ARGS:-}"
command_user="${SYNCTHING_USER:-root}"
pidfile=/run/${RC_SVCNAME}.pid
command_background=yes
start_stop_daemon_args="-d /opt/bitwarden -1 /var/log/${RC_SVCNAME}.log -2 /var/log/${RC_SVCNAME}.log"

depend() {
    use logger dns
    need net
    after firewall
}

start_pre() {
    chmod +x /opt/bitwarden/vaultwarden
    > /var/log/${RC_SVCNAME}.log
}
