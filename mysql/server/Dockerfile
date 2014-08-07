# src: https://github.com/ubermuda/sflive-docker/blob/master/docker/mysql/Dockerfile

FROM fferriere/base

MAINTAINER ferriere.florian@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y mysql-server --no-install-recommends

# change local listen to all address listen
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /usr

EXPOSE 3306

VOLUME ["/var/run/mysqld"]

CMD ["/usr/local/bin/entrypoint.sh"]
