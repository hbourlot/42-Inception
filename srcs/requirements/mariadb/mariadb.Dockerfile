FROM alpine:3.23

RUN apk update && apk add --no-cache mariadb mariadb-client bash

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/db_init.sh /tmp/db_init.sh

RUN chmod +x /tmp/db_init.sh

EXPOSE 3306

ENTRYPOINT [ "/tmp/db_init.sh" ]