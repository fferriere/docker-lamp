#!/bin/bash

if [ ! -f /var/lib/mysql/ibdata1 ]; then

    mysql_install_db > /dev/null

    ROOT_NAME=root
    ROOT_PASS=root

    # database name
    DBNAME=database
    # user and passwd user can connect at database
    USER_NAME=user
    USER_PASS=user

    /usr/bin/mysqld_safe &
    until $(mysqladmin ping > /dev/null 2>&1)
    do
        :
    done
    mysqladmin -u $ROOT_NAME create $DBNAME

    # add root@% with password, root@localhost rest with no passwd
    mysql -u $ROOT_NAME <<EOF
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$ROOT_PASS' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON user.* TO '$USER_NAME'@'%' IDENTIFIED BY '$USER_PASS';
EOF

    mysqladmin shutdown
fi

exec /usr/bin/mysqld_safe
