#!/sbin/openrc-run

depend() {
    #use logger dns
    need net
    after firewall
}

start() {
    ebegin "Starting tt-rss daemon"
    start-stop-daemon -u nobody -S -b -m -d /var/www/ttrss -p /var/run/ttrss.pid -x /usr/bin/php /var/www/ttrss/update_daemon2.php -1 /var/logs/ttrss_update_daemon2.log -2 /var/logs/ttrss_update_daemon2.log
    eend $?
}

stop() {
    ebegin "Stopping tt-rss daemon"
    start-stop-daemon -u nobody --stop --pidfile /var/run/ttrss.pid
    eend $?
    rm -rf /var/www/ttrss/lock/update_daemon.lock
}