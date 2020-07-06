#! /bin/sh

sleep 5
mysql --host=mysql --user=admin --password=tkdgur123 wordpress < /tmp/wordpress.sql
until [ $? != 0 ]
do
	sleep 1
	mysql --host=mysql --user=admin --password=tkdgur123 wordpress < /tmp/wordpress.sql
done
