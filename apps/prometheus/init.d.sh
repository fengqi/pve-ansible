#!/sbin/openrc-run

depend() {
    use logger dns
    need net
    after firewall
}

start_pre() {
    echo "Starting prometheus server"
}

start() {
    ebegin "Starting prometheus server"
    start-stop-daemon -S -b -m -p /var/run/prometheus.pid -x /opt/prometheus/prometheus -- --web.listen-address=:80 --web.enable-admin-api --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.retention.time=30d
    eend $?
}

stop() {
    ebegin "Stopping prometheus server"
    start-stop-daemon --stop --pidfile /var/run/prometheus.pid
    eend $?
}
