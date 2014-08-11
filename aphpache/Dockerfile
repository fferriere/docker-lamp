FROM fferriere/base

MAINTAINER Florian FERRIERE ferriere.florian@gmail.com

ENV DEBIAN_FRONTED noninteractive

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y apache2 libapache2-mod-php5 php5-json acl curl vim php5-mysqlnd php5-cli php5-gd php5-intl

RUN a2enmod rewrite

ADD vhost.conf /etc/apache2/sites-enabled/000-default
ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN useradd --uid 1000 --groups www-data user

# add xdebug /!\ only for dev
RUN apt-get install -y php5-xdebug
ADD xdebug.conf /xdebug.conf
RUN cat /xdebug.conf >> /etc/php5/conf.d/20-xdebug.ini

VOLUME ["/var/www/", "/var/log/apache2"]

EXPOSE 80

CMD ["/usr/local/bin/entrypoint.sh"]