# src : https://github.com/ubermuda/sflive-docker/blob/master/docker/base/Dockerfile
# author : @ubermuda

FROM stackbrew/debian:wheezy

MAINTAINER ferriere.florian@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# for run dpkg faster
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# add no-cache header for apt http requests
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# change timezone for Paris
RUN echo "Europe/Paris" > /etc/timezone; dpkg-reconfigure tzdata

RUN apt-get update -y
RUN apt-get install -y net-tools procps
