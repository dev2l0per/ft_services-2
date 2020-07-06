#!/bin/sh

export WORD_IP=$(cat /tmp/ip)
sed -i "s/WORD_IP/$WORD_IP/g" /etc/wordpress/wp-config.php
sed -i "s/WORD_IP/$WORD_IP/g" /tmp/wordpress.sql

sleep 5
sh /tmp/init-wordpress.sh & php -S 0.0.0.0:5050 -t /etc/wordpress/
