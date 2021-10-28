#!/bin/sh

DB_CID=$(docker create -e MYSQL_ROOT_PASSWORD=ch2demo mysql:5.7)
docker start $DB_CID


WP_CID=$( \
docker create \
--link $DB_CID:mysql \
-p 8000:80 \
--read-only \
-v /run/apache2/ \
--tmpfs /tmp \
wordpress:5.0.0-php7.2-apache \
)
docker start $WP_CID


MAILER_CID=$(docker create dockerinaction_02mailer:1.0)
docker start $MAILER_CID

AGENT_CID=$( \
docker create \
--link $WP_CID:insideweb \
--link $MAILER_CID:insidemailer \
dockerinaction_02agent:1.0 \
)
docker start $AGENT_CID


