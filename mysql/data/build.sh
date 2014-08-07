#!/bin/bash

MY_PATH=$(dirname $(realpath $0))

docker build -t fferriere/mysql-data $MY_PATH/.
