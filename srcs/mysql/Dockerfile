FROM alpine
RUN apk update
RUN apk upgrade
#RUN apk add mysql mysql-client
RUN apk add mysql
# -p 옵션은 부모폴더가 없으면 부모폴더도 만듦
# 이 폴더를 만들어 주는 이유는 이렇게 하면 프로그램을 실행할 때 굳이
# 앞에 절대 경로를 붙여줄 필요가 없다.
RUN mkdir -p /run/mysqld

COPY srcs/my.cnf /etc/mysql/
COPY srcs/mysql-init /tmp/
COPY srcs/run.sh /tmp/

# PV에 volume
VOLUME ["/var/lib/mysql"]

# EXPOSE. EXPOSE는 실제로는 별 의미가 없다. 왜냐하면 포트를 사용하는 서비스를 시작하면
# 자동으로 포트가 열리기 때문. 그렇다면 왜 굳이 EXPOSE를 사용하는 이유는
# 편하기 때문이다. docker run 하기 전에 도커파일의 expose를 보고 내가 원하는 포트에
# -p 옵션을 사용해서 연결해 준다. 만약 expose가 없고 처음보는 도커파일이라면 어떤 포트가
# 열리는지 알 길이 없다.
# 물론 이런 경우를 위해서 -P 옵션이 있다. 이 옵션은 컨테이너의 포트를 랜덤하게 호스트포트와 연결.
EXPOSE 3306

ENTRYPOINT ["sh", "/tmp/run.sh"]
