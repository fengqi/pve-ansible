#!/sbin/openrc-run

depend() {
    #use logger dns
    need net
    after firewall
}

start() {
    ebegin "Starting tt-rss daemon"
    start-stop-daemon -u nobody -S -b -m -d /data/www/tt-rss/ -p /var/run/ttrss.pid -x /usr/bin/php /data/www/tt-rss/update_daemon2.php -1 /data/logs/ttrss/update_daemon2.log -2 /data/logs/ttrss/update_daemon2.log
    eend $?
}

stop() {
    ebegin "Stopping tt-rss daemon"
    start-stop-daemon -u nobody --stop --pidfile /var/run/ttrss.pid
    eend $?
    rm -rf /data/www/tt-rss/lock/update_daemon.lock
}
