docker-lamp
===========

Docker use for create a LAMP configuration

This project slice in several containers :
* a base container which is used as a support for he others
* three containers for MySQL :
    * one for data
    * one for server
    * one for client
* several containers for web servers :
    * Nginx :
        * one container for the web server
        * one container for php5-fpm
    * Apache : one container contains apache and php5

For each container we have a Dockerfile and a **build.sh** script to build it.

For each container, except the base, we have a **run.sh** script for run the container.

base container
--------------

This container prepare the building of other container. Configure apt, select timezone and install some application.


mysql containers
----------------
### data container
You must wonder why use a container for the data.
This container is used for share the /var/lib/mysql directory with one or more mysql containers.
We have just to use the _--volumes-from_ argument with the name of the data container.
As the folder /var/lib/mysql is indicate as a VOLUME in docker file, datas is persistent.

This container disappear of _docker ps_ list after _docker run_ because is already finished. But we can use it's volumes.

This container is named ___fferriere-mysql-data___.

### server container
It's the most important container of mysql containers.
It contains the server (of course).

The **run.sh** script accept some arguments :
* -h, --help for show this help
* -r, --rerun for delete container and run a new container with same name
* -b, --bash=false run container with "-i -t --rm /bin/bash" arguments, incompatible with -d
* -d, --daemon=true run container as a daemon, incompatilble with -b
* -p, --bind-port=3306 bind localhost port (give by arg) with mysql port (3306)

This container is named ___fferriere-mysql-server___.

By default, root as password only from host % and not from localhost.

### client container
This container is optional. With, you can use a mysql-client compatible with the mysql-server.

The **run.sh** script of this container link and mount volumes of ___fferriere-mysql-server___.
So just with execute the script you are connected on root without password by socket protocol.
Each arguments give on run script are send to _docker run_ for launch command in container.

We don't use the **ENTRYPOINT** in Dockerfile, it replace by **CMD**. Like this we can use the command below for run bash in container.

    ./run.sh /bin/bash

aphpache container
------------------

This container run apache with php5 and xdebug (you must remove xdebug on prod).


The **run.sh** script accept some argument :
*  -h, --help for show this help
*  -P add the -P argument for docker run
*  -p bind host web port with container web port (-p 80:80)
*  --port=80 as -p but you can replace default web port on host
*  -b, --bash=false run container with "-i -t --rm /bin/bash" arguments, incompatible with -d
*  -d, --daemon=true run container as a daemon, incompatible with -b
*  -s, --src=$(pwd) set the webapp source directory (-v $src:/var/www)
*  -l, --log bind log volume with $src/../logs
*  --log-reset remove all *.log files in logpath

By default the container's /var/www is bind with the working directory, you can change it with _-s_/_--src_ option

    ./run.sh --src /home/user/public

By default no port is bind with host, you can bind with default web port (80) with _-p_ option which add _-p 80:80_ option to docker run

    ./aphpache/run.sh -p # => docker run -p 80:80

You can use th _--port_ option for select another port to bind with host

    ./aphpache/run.sh --port 8080 # => docker run -p 8080:80

The _-l_ option bind the /va/log/apache2 (on container) with $src/../logs (on host).
You can clean there log with _--log-reset_ option