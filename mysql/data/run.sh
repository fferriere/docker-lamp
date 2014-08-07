#!/bin/bash

NAME='fferriere-mysql-data'

NB_CONTAINER=$(docker ps -a | grep $NAME | wc -l)

params="$(getopt -o rh -l rerun,help --name "$0" -- "$@")"
eval set -- "$params"

RERUN=0

while true
do
    case "$1" in
        -r|--rerun)
            RERUN=1
            shift
            ;;
        -h|--help)
            echo "Run the container with mysql data"
            echo "  -h, --help for show this help"
            echo "  -r,--rerun for delete container and run a new container with same name"
            exit 0
            ;;
        --)
            shift
            break
            ;;
    esac
done

if [ "$NB_CONTAINER" != '0' ] && [ $RERUN -eq 0 ]; then
    echo 'already run'
    exit 0;
elif [ $RERUN -eq 1 ]; then
    docker rm $NAME &> /dev/null
fi

docker run -d \
  --name $NAME \
  fferriere/mysql-data
