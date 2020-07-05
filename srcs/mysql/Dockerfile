#STEP 1
FROM alpine:3.12.0
RUN apk update && apk upgrade
COPY srcs/ip /tmp/

#STEP 2
RUN apk add mysql mysql-client
COPY srcs/my.cnf /etc/mysql/
COPY srcs/mysql-init /tmp/

#STEP 3
VOLUME ["/var/lib/mysql"]
EXPOSE 3306

#STEP 4
RUN rm -rf /var/cache/apk/*
RUN mkdir -p /run/mysqld
COPY srcs/entrypoint.sh /tmp/
ENTRYPOINT ["sh", "/tmp/entrypoint.sh"]
