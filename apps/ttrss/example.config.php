<?php

// https://tt-rss.org/wiki/GlobalConfig/
// https://tt-rss.org/ttrss-docs/classes/Config.html

putenv('TTRSS_DB_TYPE=__TTRSS_DB_TYPE__');
putenv('TTRSS_DB_HOST=__TTRSS_DB_HOST__');
putenv('TTRSS_DB_PORT=__TTRSS_DB_PORT__');
putenv('TTRSS_DB_NAME=__TTRSS_DB_NAME__');
putenv('TTRSS_DB_USER=__TTRSS_DB_USER__');
putenv('TTRSS_DB_PASS=__TTRSS_DB_PASS__');
putenv('TTRSS_SELF_URL_PATH=http://__TTRSS_HOST__');
putenv("TTRSS_SESSION_COOKIE_LIFETIME='__TTRSS_SESSION_COOKIE_LIFETIME__'");
putenv('TTRSS_PLUGINS=__TTRSS_PLUGINS__');

putenv('TTRSS_SMTP_SERVER=__TTRSS_SMTP_SERVER__');
putenv('TTRSS_SMTP_LOGIN=__TTRSS_SMTP_LOGIN__');
putenv('TTRSS_SMTP_FROM_ADDRESS=__TTRSS_SMTP_FROM_ADDRESS__');
putenv('TTRSS_SMTP_PASSWORD=__TTRSS_SMTP_PASSWORD__');
putenv('TTRSS_SMTP_SECURE=__TTRSS_SMTP_SECURE__');
putenv('TTRSS_SMTP_SKIP_CERT_CHECKS=__TTRSS_SMTP_SKIP_CERT_CHECKS__');
