# src: https://github.com/ubermuda/m6web-docker/blob/master/mysql-client/Dockerfile

FROM fferriere/base

MAINTAINER ferriere.florian@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y mysql-client

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["mysql"]
