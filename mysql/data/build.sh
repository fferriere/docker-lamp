#!/bin/bash

MY_PATH=$(dirname $(realpath $0))

docker build -t $DOCKER_NAMESPACE/mysql-data $MY_PATH/.
