#!/bin/bash

params="$(getopt -o lhPbdps: -l help,log,log-reset,bash:,daemon:,port:,src: --name "$0" -- $@)"
eval set -- "$params"

USE_DAEMON=1
USE_BASH=0
HOST_PORT=''
HOST_PORT_NUM=''
SRC_PATH=$(pwd)
DEFAULT_PORT='80'
USE_LOG=0
LOG_RESET=0

while true
do
    case "$1" in
        -l|--log)
            shift
            USE_LOG=1
            ;;
        --log-reset)
            shift
            LOG_RESET=1
            ;;
        -b)
            shift
            USE_BASH=1
            ;;
        --bash)
            shift
            if [ "$1" == "true" ]; then
                USE_BASH=1
            else
                USE_BASH=0
            fi
            shift
            ;;
        -d)
            shift
            USE_DAEMON=1
            ;;
        --daemon)
            shift
            if [ "$1" == "true" ]; then
                USE_DAEMON=1
            else
                USE_DAEMON=0
            fi
            shift
            ;;
        -P)
            shift
            HOST_PORT='-P'
            ;;
        -p)
            shift
            HOST_PORT_NUM=$DEFAULT_PORT
            ;;
        --port)
            shift
            if [ "$1" -gt 0 ]; then
                HOST_PORT_NUM="$1"
            fi
            shift
            ;;
        -s|--src)
            shift
            SRC_PATH=$(realpath $1)
            shift
            ;;
        -h|--help)
            echo "Run the container with apache & PHP5"
            echo "  -h, --help show this help"
            echo "  -P add the -P argument for docker run"
            echo "  -p bind host web port with container web port (-p 80:80)"
            echo "  --port=80 as -p but you can replace default web port on host"
            echo "  -b, --bash=false run container with \"-i -t --rm /bin/bash\" arguments"
            echo "              incompatible with -d"
            echo "  -d, --daemon=true run container as a daemon"
            echo "              incompatible with -b"
            echo "  -s, --src=\$(pwd) set the webapp source directory (-v \$src:/var/www)"
            echo "  -l, --log bind log volume with \$src/../logs"
            echo "  --log-reset remove all *.log files in logpath"
            exit
            ;;
        --)
            shift
            break
            ;;
    esac
done

DOCKER_ARGS='--rm'
BASH=''
if [ $USE_BASH -eq 1 ]; then
    DOCKER_ARGS=$DOCKER_ARGS' -i -t'
    BASH='/bin/bash'
elif [ $USE_DAEMON -eq 1 ]; then
    DOCKER_ARGS='-d'
fi

if [[ -n "$HOST_PORT_NUM" && "$HOST_PORT_NUM" -gt "0" ]]; then
    HOST_PORT=$HOST_PORT" -p $HOST_PORT_NUM:80"
fi

LOG_ARGS=''
if [ $USE_LOG -eq 1 ]; then

    logpath=$(dirname $SRC_PATH)"/logs";

    if [ ! -d $logpath ]; then
        mkdir $logpath
    fi

    if [ $LOG_RESET -eq 1 ]; then
        echo 'clean log'
        rm -f $logpath"/*.log"
    fi

    LOG_ARGS="-v $logpath:/var/log/apache2"
fi

docker run $DOCKER_ARGS \
    $HOST_PORT \
    $LOG_ARGS \
    -v $SRC_PATH:/var/www \
    fferriere/aphpache $BASH
