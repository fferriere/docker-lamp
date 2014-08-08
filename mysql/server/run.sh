#!/bin/bash

NAME='fferriere-mysql-server'

NB_CONTAINER_RUN=$(docker ps | grep $NAME | wc -l)
NB_CONTAINER=$(docker ps -a | grep $NAME | wc -l)

params="$(getopt -o rhbdp: -l rerun,help,bash:,daemon:,bind-port:,no-volume --name "$0" -- "$@")"
eval set -- "$params"

RERUN=0
USE_DAEMON=1
USE_BASH=0
HOST_PORT=''
VOLUME_ARG='--volumes-from fferriere-mysql-data'

while true
do
    case "$1" in
        -r|--rerun)
            RERUN=1
            shift
            ;;
        -p|--bind-port)
            shift
            if [ "$1" -gt 0 ]; then
                HOST_PORT="-p $1:3306"
            fi
            shift
            ;;
        -d)
            USE_DAEMON=1
            shift
            ;;
        --daemon)
            shift
            if [ "$1" == "true" ]; then
                USE_DAEMON=1
            fi
            shift
            ;;
        -b)
            USE_BASH=1
            shift
            ;;
        --bash)
            shift
            if [ "$1" == "true" ]; then
                USE_BASH=1
            fi
            shift
            ;;
        --no-volume)
            VOLUME_ARG=''
            shift
            ;;
        -h|--help)
            echo "Run the container with mysql server"
            echo "  -h, --help for show this help"
            echo "  -r, --rerun for delete container and run a new container with same name"
            echo "  -b, --bash=false run container with \"-i -t --rm /bin/bash\" arguments"
            echo "             incompatible with -d"
            echo "  -d, --daemon=true run container as a daemon"
            echo "             incompatilble with -b"
            echo "  -p, --bind-port=3306 bind localhost port (give by arg) with mysql port (3306)"
            exit 0
            ;;
        --)
            shift
            break
            ;;
    esac
done


if [ "$NB_CONTAINER" -gt 0 ] && [ $RERUN -eq 0 ]; then
    echo 'already run'
    exit 0;
elif [ $RERUN -eq 1 ]; then

    if [ "$NB_CONTAINER_RUN" -gt 0 ]; then
        docker stop $NAME &> /dev/null
    fi
    docker rm $NAME &> /dev/null
fi

DOCKER_ARGS='-d'
BASH=''
if [ $USE_BASH -eq 1 ]; then
    DOCKER_ARGS='-i -t --rm'
    BASH='/bin/bash'
fi

DOCKER_ARGS=$DOCKER_ARGS' '$HOST_PORT

docker run $DOCKER_ARGS \
  --name $NAME \
  $VOLUME_ARG \
  fferriere/mysql-server $BASH
