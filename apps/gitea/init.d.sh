#!/sbin/openrc-run

depend() {
    use logger dns
    need net
    after firewall
}

start_pre() {
    chmod +x /home/git/gitea
    setcap CAP_NET_BIND_SERVICE=+eip /home/git/gitea
}

start() {
    ebegin "Starting gitea server"
    start-stop-daemon -u git -d /home/git -S -b -m -p /var/run/gitea.pid -x /home/git/gitea
    eend $?
}

stop() {
    ebegin "Stopping gitea server"
    start-stop-daemon -u git -d /home/git --stop --pidfile /var/run/gitea.pid
    eend $?
}
