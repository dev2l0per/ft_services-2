#!/bin/sh

#yopark:admin, user1:admin, user2:admin

sed -i "s/CHANGETOIP/`cat /tmp/ip`/g" /etc/wordpress/wp-config.php
sed -i "s/CHANGETOIP/`cat /tmp/ip`/g" /tmp/wordpress.sql

sleep 5
sh /tmp/launch-wordpress.sh & php -S 0.0.0.0:5050 -t /etc/wordpress/
