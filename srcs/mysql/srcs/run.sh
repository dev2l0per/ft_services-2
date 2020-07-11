#!/bin/sh

# apk add mysql을 하면 mysql이 설치는 되지만 "mysql server"에 관련된 초기 세팅은 전혀 되어있지 않은 상태다. 따라서 서버에 관한 초기세팅을 해줘야하는데 mysql_install_db가 이 세팅을 도와준다. 그리고 --user=root로 하는 이유는 alpine 컨테이너에 우리가 다른 사용자를 만들지 않았기 때문. 그리고 만약 다른 사용자를 추가해서 그 유저로 하면 비밀번호를 추가로 입력해야 하는 불편함이 있다. 따라서 그냥 root로 편하게 하자.
mysql_install_db --user=root
# bootstrap옵션을 사용해 주는 이유는 mysql 서버가 시작되기 전에 먼저 DB 테이블이 만들어져야 하기 때문. 테이블이 만들어져 있지 않은 상황에서 wordpress.sql 데이터가 들어 갈 수 없다. 따라서 wordpress.sql을 해주기 전에 sql 테이터가 입력될 환경을 조성해 주는 것.
# 그리고 mysqld --user=root < init 이 아니라 --bootstrap 옵션으로 먼저 테이블을 생성하고 mysqld --user=root를 하는 이유는 mysqld --user=root는 "서버"를 시작하는 명령이기 때문이다. 서버를 시작하고 나서는 데이터를 넣기 힘들기 때문에 서버를 시작하기 전에 "테이블"을 생성하고 만든 테이블을 갖는 서버를 시작하는 것.
# --bootstrap 옵션을 붙여주는 이유는 결국 서버를 "진짜"로 시작하기 전에 테이블을 만들기 위함
mysqld --user=root --bootstrap < /tmp/mysql-init
# 서버 시작. 서버가 돌아가는 와중에 이제 만들어진 wordpress 테이블에 wordpress.sql 데이터가 들어온다. 이 작업은 wordpress.sql에서 해준다.
mysqld --user=root 
