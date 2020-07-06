FROM alpine
RUN apk update
RUN apk upgrade
COPY srcs/ip /tmp/

RUN apk add mysql mysql-client
COPY srcs/my.cnf /etc/mysql/
COPY srcs/mysql-init /tmp/

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

RUN rm -rf /var/cache/apk/*
RUN mkdir -p /run/mysqld
COPY srcs/run.sh /tmp/
ENTRYPOINT ["sh", "/tmp/run.sh"]
