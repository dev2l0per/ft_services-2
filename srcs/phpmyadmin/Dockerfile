#STEP 1
FROM alpine:3.12.0
RUN apk update && apk upgrade
COPY srcs/ip /tmp/

#STEP 2
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar -xvf /phpMyAdmin-4.9.5-all-languages.tar.gz
RUN rm -f /phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv /phpMyAdmin-4.9.5-all-languages /etc/phpmyadmin
COPY srcs/config.inc.php /etc/phpmyadmin/

#STEP 3
EXPOSE 5000

#STEP 4
RUN rm -rf /var/cache/apk/*
COPY srcs/entrypoint.sh /tmp/
ENTRYPOINT ["sh", "/tmp/entrypoint.sh"]
