#! /bin/sh

sleep 5
mysql --host=mysql --user=admin --password=tkdgur123 wordpress < /tmp/wordpress.sql
