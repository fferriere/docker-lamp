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
